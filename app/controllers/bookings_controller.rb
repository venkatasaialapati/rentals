class BookingsController < ApplicationController
  before_action :set_booking, only: %i[ show edit update destroy accept reject ]
  before_action :authenticate_user!

  def index
    @bookings = current_user.admin? ? Booking.includes(:user, :vehicle).all : current_user.bookings.includes(:vehicle)
  
    respond_to do |format|
      format.html # Renders index.html.erb
      format.json { 
        render json: @bookings.as_json(
          only: [:id, :latitude, :longitude, :address, :status], 
          methods: [:user_email],
          include: {
            user: { only: [:id, :email, :name] },  # Include user details
            vehicle: { only: [:id, :name, :vehicle_type] } # Include vehicle details
          }
        ) 
      }
    end
  end
  

  # GET /bookings/1
  def show
    redirect_to booking_payment_path(@booking), alert: "You need to complete the payment first!" if @booking.status != "paid"
  end

  # GET /bookings/new
  def new
    @booking = Booking.new
  end

  # POST /bookings
  def create
    @booking = current_user.bookings.build(booking_params)
    @booking.total_price = calculate_total_price(@booking)
  
    # Store latitude & longitude if provided
    if params[:latitude].present? && params[:longitude].present?
      @booking.latitude = params[:latitude]
      @booking.longitude = params[:longitude]
    end
  
    if @booking.save
      redirect_to booking_payment_path(@booking), notice: "Booking successful! Proceed to payment."
    else
      flash[:alert] = "Booking failed. Please check your details and try again."
      render :new, status: :unprocessable_entity
    end
  end
  

  # PATCH /bookings/1
  def update
    if @booking.update(booking_params)
      redirect_to @booking, notice: "Booking was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # ADMIN: Accept a booking
  def accept
    if current_user.admin?
      @booking.update(status: "confirmed")
      BookingMailer.booking_accepted(@booking.user, @booking).deliver_now
      redirect_to bookings_path, notice: "Booking has been accepted."
    else
      redirect_to bookings_path, alert: "Unauthorized action."
    end
  end

  # ADMIN: Reject a booking
  def reject
    if current_user.admin?
      @booking.update(status: "rejected")
      BookingMailer.booking_rejected(@booking.user, @booking).deliver_now
      redirect_to bookings_path, alert: "Booking has been rejected."
    else
      redirect_to bookings_path, alert: "Unauthorized action."
    end
  end

  # DELETE /bookings/1 (Admin: Delete | User: Cancel)
  def destroy
    if current_user.admin?
      @booking.destroy
      redirect_to bookings_path, notice: "Booking has been deleted."
    elsif @booking.user == current_user
      @booking.update(status: "canceled")
      BookingMailer.booking_cancellation(@booking.user, @booking).deliver_now
      redirect_to bookings_path, notice: "Your booking has been canceled. A refund will be processed."
    else
      redirect_to bookings_path, alert: "Unauthorized action."
    end
  end


 


  private

  def set_booking
    @booking = Booking.find(params[:id])
  end

  def booking_params
    params.require(:booking).permit(:start_date, :end_date, :address, :proof_document, :vehicle_id, :status, :phone_number, :latitude, :longitude)
  end
  

  def calculate_total_price(booking)
    vehicle = Vehicle.find(booking.vehicle_id)
    days = [(booking.end_date.to_date - booking.start_date.to_date).to_i, 1].max
    total_price = vehicle.price * days
    total_price.positive? ? total_price : total_price.abs
  end
end

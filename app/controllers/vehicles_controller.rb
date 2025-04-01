class VehiclesController < ApplicationController
  before_action :set_vehicle, only: %i[show edit update destroy toggle_availability]
  before_action :authenticate_user!, except: %i[index show]
  before_action :authorize_admin, except: %i[index show]

  # GET /vehicles or /vehicles.json
  def index
    @vehicles = Vehicle.all
  
    # Filter by location if selected
    if params[:location].present?
      @vehicles = @vehicles.where(location: params[:location])
    end
  
    # Search by vehicle name
    if params[:query].present?
      @vehicles = @vehicles.where("name LIKE ?", "%#{params[:query]}%")
    end
  end
  

  # GET /vehicles/1 or /vehicles/1.json
  def show
  end

  # GET /vehicles/new
  def new
    @vehicle = Vehicle.new
  end

  # GET /vehicles/1/edit
  def edit
  end

  # POST /vehicles or /vehicles.json
  def create
    @vehicle = Vehicle.new(vehicle_params)
    Rails.logger.debug "Image Param: #{params[:vehicle][:image].inspect}"
    respond_to do |format|
      if @vehicle.save
        format.html { redirect_to @vehicle, notice: "Vehicle was successfully created." }
        format.json { render :show, status: :created, location: @vehicle }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @vehicle.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /vehicles/1 or /vehicles/1.json
  def update
    respond_to do |format|
      if @vehicle.update(vehicle_params)
        format.html { redirect_to @vehicle, notice: "Vehicle was successfully updated." }
        format.json { render :show, status: :ok, location: @vehicle }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @vehicle.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /vehicles/1 or /vehicles/1.json
  def destroy
    @vehicle.bookings.destroy_all  # Remove all bookings before deleting the vehicle
    if @vehicle.destroy
      redirect_to vehicles_path, notice: "Vehicle deleted successfully."
    else
      redirect_to vehicles_path, alert: "Error deleting vehicle."
    end
  end

  # PATCH /vehicles/:id/toggle_availability
  def toggle_availability
    @vehicle.update(available: !@vehicle.available)
    redirect_to vehicles_path, notice: "Vehicle availability updated!"
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_vehicle
    @vehicle = Vehicle.find(params[:id])
  end
  
# Only allow a list of trusted parameters through.
def vehicle_params
  params.require(:vehicle).permit(:name, :vehicle_type, :seating_capacity, :price, :image, :available, :location)
end

  # Restrict access to admins only
  def authorize_admin
    unless current_user.admin?
      redirect_to root_path, alert: "Access Denied!"
    end
  end
end

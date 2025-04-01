class PaymentsController < ApplicationController
    before_action :set_booking
  
    def new
      @payment = Payment.new
    end

    def show
        @booking = Booking.find(params[:booking_id])
        @payment = @booking.payment # Assuming Payment is associated with Booking
    
        if @payment
          render :show
        else
          redirect_to new_booking_payment_path(@booking), alert: "No payment found for this booking."
        end
      end


      def create
        @booking = Booking.find(params[:booking_id])
      
        # Process the payment (using ActiveMerchant or your payment logic)
        payment = @booking.build_payment(amount: @booking.total_price, status: "completed")
      
        if payment.save
          @booking.update(status: "paid")  # ✅ Update booking status
      
          # ✅ Send payment confirmation email
          PaymentMailer.payment_confirmation(@booking.user, @booking).deliver_now
      
          redirect_to booking_path(@booking), notice: "Payment successful! A confirmation email has been sent."
          return  # 🔴 Ensures method exits after redirect
        end
      
        redirect_to booking_path(@booking), alert: "Payment failed. Please try again."
      end
      
      
  
    def process_payment
      # Simulating payment processing delay
      sleep(3)
      redirect_to booking_path(@booking), notice: "Payment successful!"
    end
    private
    def set_booking
      @booking = Booking.find(params[:booking_id])
    end
    private

def payment_params
  params.permit(:first_name, :last_name, :card_number, :expiry_date, :cvv, :amount, :booking_id)
end
 end
  
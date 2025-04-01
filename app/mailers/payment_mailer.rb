class PaymentMailer < ApplicationMailer
    def payment_confirmation(user, booking)
      @user = user
      @booking = booking
      mail(to: @user.email, subject: "Payment Confirmation - Booking ##{@booking.id}")
    end
  end
  
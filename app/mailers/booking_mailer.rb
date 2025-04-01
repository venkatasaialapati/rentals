class BookingMailer < ApplicationMailer
    default from: 'your-email@gmail.com'
  
  
    def booking_cancellation(user, booking)
        @user = user
        @booking = booking

        mail(to: @user.email, subject: "Your Booking has been Canceled")
      end

      def booking_rejected(user, booking)
        @user = user
        @booking = booking
        mail(to: @user.email, subject: "Your booking has been rejected")
      end
    
  
        def booking_accepted(user, booking)
          @user = user
          @booking = booking
          mail(to: @user.email, subject: "Your booking has been accepted!")
        end
    
  end
  
class Admin::DashboardController < ApplicationController
    before_action :authenticate_user!
    before_action :authorize_admin
  
    def index 
      # Fetch bookings per month for 2023 & 2024 (works with SQLite3)
      @todays_bookings = Booking.where(created_at: Time.zone.today.all_day).count
      @total_booking_amount = Booking.sum(:total_price) # Assuming total_price column exists in Booking table
      @bookings_2023 = bookings_by_month(2023)
      @bookings_2024 = bookings_by_month(2024)
      @total_users = User.count
      @total_vehicles = Vehicle.count
      @total_bookings = Booking.count
      @booked_vehicles_count = Booking.distinct.count(:vehicle_id)
      @booking_percentage = @total_vehicles.positive? ? (@booked_vehicles_count.to_f / @total_vehicles * 100).round(2) : 0
    
      if params[:user_id].present?
        @selected_user = User.find_by(id: params[:user_id])
    
        if @selected_user
          @user_bookings_count = @selected_user.bookings.count
          @total_spent = @selected_user.bookings.sum(:total_price) # Assuming total_price stores booking cost
        else
          @user_bookings_count = 0
          @total_spent = 0
        end
      else
        @selected_user = nil
        @user_bookings_count = 0
        @total_spent = 0
      end
    end
    
    private
  
    def authorize_admin
      redirect_to root_path, alert: "Access Denied!" unless current_user.admin?
    end


  # Fetch bookings per month for a given year (SQLite3-compatible)
  def bookings_by_month(year)
    months = (1..12).map { |m| Date.new(year, m, 1).strftime('%Y-%m') }
    counts = Booking.where("strftime('%Y', created_at) = ?", year.to_s)
                    .group("strftime('%Y-%m', created_at)").count

    # Ensure all 12 months are included (fill missing months with 0)
    months.map { |month| counts[month] || 0 }
  end
    
  end
  
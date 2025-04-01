json.extract! booking, :id, :user_id, :vehicle_id, :start_date, :end_date, :total_price, :status, :created_at, :updated_at
json.url booking_url(booking, format: :json)

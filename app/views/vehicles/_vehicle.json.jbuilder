json.extract! vehicle, :id, :name, :vehicle_type, :seating_capacity, :price, :image, :created_at, :updated_at
json.url vehicle_url(vehicle, format: :json)

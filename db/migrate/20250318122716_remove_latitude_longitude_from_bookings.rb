class RemoveLatitudeLongitudeFromBookings < ActiveRecord::Migration[7.1]
  def change
    remove_column :bookings, :latitude, :float
    remove_column :bookings, :longitude, :float
  end
end

class AddLocationToVehicles < ActiveRecord::Migration[7.1]
  def change
    add_column :vehicles, :location, :string
  end
end

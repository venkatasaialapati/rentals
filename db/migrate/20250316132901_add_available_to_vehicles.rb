class AddAvailableToVehicles < ActiveRecord::Migration[7.1]
  def change
    add_column :vehicles, :available, :boolean
  end
end

class CreateVehicles < ActiveRecord::Migration[7.1]
  def change
    create_table :vehicles do |t|
      t.string :name
      t.string :vehicle_type
      t.integer :seating_capacity
      t.decimal :price
      t.string :image

      t.timestamps
    end
  end
end

class RemoveImageFromVehicles < ActiveRecord::Migration[7.1]
  def change
    remove_column :vehicles, :image, :string
  end
end

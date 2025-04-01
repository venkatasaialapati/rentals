class CreatePayments < ActiveRecord::Migration[7.1]
  def change
    create_table :payments do |t|
      t.integer :booking_id, null: true
      t.decimal :amount, precision: 10, scale: 2, null: false
      t.string :status, default: "pending"
      t.string :transaction_id
      t.string :first_name
      t.string :last_name
      t.string :card_number
      t.string :expiry_date
      t.string :cvv
      t.string :payment_method



      t.timestamps
    end

    add_foreign_key :payments, :bookings
  end
end

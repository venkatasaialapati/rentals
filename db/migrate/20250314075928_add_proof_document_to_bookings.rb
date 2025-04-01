class AddProofDocumentToBookings < ActiveRecord::Migration[7.1]
  def change
    add_column :bookings, :proof_document, :string
  end
end


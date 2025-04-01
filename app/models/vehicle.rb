class Vehicle < ApplicationRecord
    has_many :bookings, dependent: :destroy
    has_one_attached :image
    validates :location, presence: true


    validates :name, :vehicle_type, :seating_capacity, :price, presence: true

    scope :by_location, ->(location) { where(location: location) if location.present? }


  end
  
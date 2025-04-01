class Booking < ApplicationRecord
  belongs_to :user
  belongs_to :vehicle
  before_save :set_default_status
  has_one :payment, dependent: :destroy
  geocoded_by :address
  after_validation :geocode, if: ->(obj) { obj.address.present? && obj.latitude.nil? }

  


  has_one_attached :proof_document  # This adds file upload capability

  validates :start_date, :end_date, :address, presence: true
  validates :proof_document, presence: true
  validates :phone_number, presence: true, format: { with: /\A\d{10}\z/, message: "must be a valid 10-digit number" }


  def user_email
    user.email
  end


  def process_payment(card_details)
    amount_in_cents = (self.total_price * 100).to_i  # Convert price to cents

    # Fake credit card details (BogusGateway accepts any number)
    credit_card = ActiveMerchant::Billing::CreditCard.new(
      first_name: card_details[:first_name],
      last_name: card_details[:last_name],
      number: card_details[:card_number],  # Any number will work
      month: card_details[:expiry_month],
      year: card_details[:expiry_year],
      verification_value: card_details[:cvv]
    )

    if credit_card.valid?
      response = GATEWAY.purchase(amount_in_cents, credit_card)
      return response.success? ? response.authorization : nil
    else
      return nil
    end
  end


  private

  def set_default_status
    self.status ||= "pending"
  end

end

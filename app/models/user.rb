class User < ApplicationRecord
  # Include default Devise modules. Others available are:
  # :lockable, :timeoutable, :trackable, and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

   has_many :bookings, dependent: :destroy 
  # Define roles for users
  enum role: { user: 0, admin: 1 }

  # Ensure default role is set to 'user' if not provided
  before_create :set_default_role

  private

  def set_default_role
    self.role ||= :user
  end
  def full_name
    "#{first_name} #{last_name}"
  end

  def self.admin
    find_by(role: "admin") # Returns only ONE admin user
  end

  class User < ApplicationRecord
    def admin?
      role == "admin"
    end
  end
  
end


class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
  :recoverable, :rememberable, :validatable

  has_many :favorites, dependent: :destroy

  before_validation :generate_api_key, on: :create
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, presence: true, length: { minimum: 6 }
  validates :api_key, presence: true, uniqueness: true

  private def generate_api_key
    return if self.api_key.present?

    loop do
      self.api_key = SecureRandom.hex(16)
      break unless User.exists?(api_key: api_key)
    end
  end
end

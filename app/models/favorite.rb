class Favorite < ApplicationRecord
  belongs_to :user

  validates :user, presence: true
  validates :restaurant_id, presence: true, uniqueness: { scope: :user_id, message: 'has already been favorited by this user' }
end

FactoryBot.define do
  factory :favorite do
    user { nil }
    restaurant_id { SecureRandom.alphanumeric(27) }
  end
end

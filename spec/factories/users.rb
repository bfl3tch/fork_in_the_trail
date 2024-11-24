FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    password { 'securepassword' }
    api_key { SecureRandom.hex(20) }
  end
end

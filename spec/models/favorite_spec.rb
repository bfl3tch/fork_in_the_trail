require 'rails_helper'

RSpec.describe Favorite, type: :model do
  let(:user) { create(:user) }

  describe 'associations' do
    it { should belong_to(:user) }
  end

  describe 'validations' do
    subject { create(:favorite, user: user, restaurant_id: 'ChIJN1t_tDeuEmsRUsoyG83frY4') }

    it { should validate_presence_of(:user) }
    it { should validate_presence_of(:restaurant_id) }
    it {
      should validate_uniqueness_of(:restaurant_id)
        .scoped_to(:user_id)
        .with_message('has already been favorited by this user')
    }
  end

  describe 'creating a favorite' do
    it 'is valid with valid attributes' do
      favorite = Favorite.new(user: user, restaurant_id: 'ChIJN1t_tDeuEmsRUsoyG83frY4')
      expect(favorite).to be_valid
    end

    it 'is invalid without a user' do
      favorite = Favorite.new(restaurant_id: 'ChIJN1t_tDeuEmsRUsoyG83frY4')
      expect(favorite).not_to be_valid
      expect(favorite.errors[:user]).to include("can't be blank")
    end

    it 'is invalid without a restaurant_id' do
      favorite = Favorite.new(user: user)
      expect(favorite).not_to be_valid
      expect(favorite.errors[:restaurant_id]).to include("can't be blank")
    end

    it 'is invalid if the same restaurant_id is favorited twice by the same user' do
      Favorite.create!(user: user, restaurant_id: 'ChIJN1t_tDeuEmsRUsoyG83frY4')
      duplicate_favorite = Favorite.new(user: user, restaurant_id: 'ChIJN1t_tDeuEmsRUsoyG83frY4')

      expect(duplicate_favorite).not_to be_valid
      expect(duplicate_favorite.errors[:restaurant_id]).to include('has already been favorited by this user')
    end
  end
end

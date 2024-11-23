require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { create(:user) }
  let(:user_2) { create(:user) }

  describe 'Validations' do
    context 'email' do
      it 'is valid with a valid email' do
        user.email = 'test@example.com'
        expect(user).to be_valid
      end

      it 'is invalid without an email' do
        user.email = nil
        expect(user).to_not be_valid
        expect(user.errors[:email]).to include("can't be blank")
      end

      it 'is invalid with a duplicate email' do
        create(:user, email: 'duplicate@example.com')
        user.email = 'duplicate@example.com'
        expect(user).to_not be_valid
        expect(user.errors[:email]).to include('has already been taken')
      end

      it 'is invalid with a poorly formatted email' do
        user.email = 'invalid_email'
        expect(user).to_not be_valid
        expect(user.errors[:email]).to include('is invalid')
      end
    end

    context 'password' do
      it 'is valid with a password of sufficient length' do
        user.password = 'securepassword'
        expect(user).to be_valid
      end

      it 'is invalid without a password' do
        user.password = nil
        expect(user).to_not be_valid
        expect(user.errors[:password]).to include("can't be blank")
      end

      it 'is invalid with a short password' do
        user.password = '123'
        expect(user).to_not be_valid
        expect(user.errors[:password]).to include('is too short (minimum is 6 characters)')
      end
    end

    context 'api_key' do
      it 'is valid with a unique API key' do
        user.api_key = SecureRandom.hex(20)

        expect(user).to be_valid
      end

      it 'is invalid without an API key' do
        user.api_key = nil

        expect(user).to_not be_valid
        expect(user.errors[:api_key]).to include("can't be blank")
      end

      it 'is invalid with a duplicate API key' do
        user.api_key = user_2.api_key

        expect(user).to_not be_valid
        expect(user.errors[:api_key]).to include('has already been taken')
      end
    end
  end

  describe 'Callbacks' do
    it 'generates a unique API key on creation' do
      expect { create(:user) }
    end

    it 'raises if api key removed' do
      user.api_key = nil

      expect { user.save! }.to raise_error(ActiveRecord::RecordInvalid)
    end

    it 'does not generate a new API key if one exists' do
      existing_key = SecureRandom.hex(20)
      user.api_key = existing_key
      user.save
      expect(user.api_key).to eq(existing_key)
    end
  end
end

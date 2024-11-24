require 'rails_helper'

RSpec.describe 'Users API', type: :request do
  describe 'POST /api/v1/users' do
    context 'with valid parameters' do
      let(:valid_params) do
        {
          user: {
            email: 'test@example.com',
            password: 'password123',
            password_confirmation: 'password123'
          }
        }
      end

      it 'creates a new user and returns serialized user data' do
        post users_path, params: valid_params

        expect(response).to have_http_status(:created)
        expect(json[:data][:attributes].keys).to contain_exactly("email", "api_key")
      end
    end

    context 'with invalid parameters' do
      let(:invalid_params) do
        {
          user: {
            email: 'test@example.com',
            password: 'password123',
            password_confirmation: 'wrongpassword'
          }
        }
      end

      it 'returns an error with validation messages' do
        post users_path, params: invalid_params

        expect(response).to have_http_status(:unprocessable_entity)
        expect(json['errors']).to include("Password confirmation doesn't match Password")
      end
    end

    context 'with missing parameters' do
      let(:missing_params) { { user: { email: '' } } }

      it 'returns a bad request error' do
        post users_path, params: missing_params

        expect(response).to have_http_status(:unprocessable_entity)
        expect(json['errors']).to include("Email can't be blank",
                                          "Password can't be blank")
      end
    end

    private def json
      JSON.parse(response.body).with_indifferent_access
    end
  end
end

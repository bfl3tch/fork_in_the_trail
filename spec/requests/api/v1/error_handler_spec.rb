require 'rails_helper'

RSpec.describe 'Error Handling', type: :request do
  let(:user) { create(:user) }

  describe 'Error Scenarios' do
    context 'when the JSON request is malformed' do
      it 'returns a 400 Bad Request' do
        headers = { 'CONTENT_TYPE' => 'application/json' }
        malformed_json = '{ "user": { "email": "test@example.com", "password": "password123" ' # Missing closing braces

        post api_v1_users_path, params: malformed_json, headers: headers

        expect(response).to have_http_status(:bad_request)
        expect(json['error']).to eq('Invalid JSON format')
        expect(json['metadata']).to be_present
      end
    end

    context 'when a required parameter is missing' do
      it 'returns a 400 Bad Request' do
        post api_v1_restaurants_search_path, params: {}, headers: { 'X-Api-Key' => user.api_key }

        expect(response).to have_http_status(:bad_request)
        expect(json['error']).to eq('Query param empty or missing')
        expect(json['metadata']).to be_present
      end
    end

    context 'when the user is unauthorized' do
      it 'returns a 401 Unauthorized' do
        post api_v1_restaurants_search_path, params: { query: 'Pizza near me' }

        expect(response).to have_http_status(:unauthorized)
        expect(json['error']).to eq('Unauthorized request')
        expect(json['metadata']).to be_present
      end
    end

    private def json
      JSON.parse(response.body).with_indifferent_access
    end
  end
end

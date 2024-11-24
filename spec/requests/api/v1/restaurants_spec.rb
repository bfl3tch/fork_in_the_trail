require 'rails_helper'

RSpec.describe 'Restaurants', type: :request do
  let(:user) { create(:user) }
  let(:headers) { { 'X-Api-Key' => user.api_key } }
  let(:query) { 'lunch near Satellite Beach, FL' }

  describe 'post#search', :vcr do
    context 'with valid query' do
      it 'returns a list of restaurants' do
        post api_v1_restaurants_search_path, params: { query: query }, headers: headers

        expect(response).to have_http_status(:ok)
        expect(json['result']).to be_an(Array)
        expect(json['result'].first).to include(
          'name' => be_a(String),
          'address' => be_a(String),
          'price_level' => be_a(String)
        )
      end
    end

    context 'when missing the auth header' do
      it 'returns an unauthorized error' do
        post api_v1_restaurants_search_path, params: { query: query }

        expect(response).to have_http_status(:unauthorized)
        expect(json['error']).to eq('Unauthorized request')
      end
    end

    context 'when containing an invalid auth header' do
      let(:headers) { { 'X-Api-Key' => 'badkey' } }

      it 'returns an unauthorized error' do
        post api_v1_restaurants_search_path, params: { query: query }, headers: headers

        expect(response).to have_http_status(:unauthorized)
        expect(json['error']).to eq('Unauthorized request')
      end
    end

    private def json
      JSON.parse(response.body).with_indifferent_access
    end
  end
end

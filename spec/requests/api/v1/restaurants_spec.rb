require 'rails_helper'

RSpec.describe 'Restaurants', type: :request do
  let(:user) { create(:user) }
  let(:headers) { { 'X-Api-Key' => user.api_key } }
  let(:query) { 'steak' }
  let(:surf_query) { 'surf' }

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

      it 'returns a list of restaurants for another query' do
        post api_v1_restaurants_search_path, params: { query: surf_query }, headers: headers

        expect(response).to have_http_status(:ok)
        expect(json['result']).to be_an(Array)
        expect(json['result'].first).to include(
          'name' => be_a(String),
          'address' => be_a(String),
          'price_level' => be_a(String)
        )
      end
    end

    context 'when the API connection fails' do
      before do
        allow(RestaurantLookupService).to receive(:connection)
          .and_raise(Faraday::ConnectionFailed.new('Connection error'))
      end

      it 'renders the connection error message' do
        post '/search', params: { query: query }, headers: headers

        expect(response).to have_http_status(:unprocessable_entity)
        expect(json['error']).to eq('Connection issue, please try again.')
        expect(json['metadata']).to have_key('timestamp')
      end
    end

    context 'when the API returns invalid JSON' do
      before do
        stub_request(:post, 'https://places.googleapis.com/v1/places:searchText')
          .to_return(status: 200, body: 'Invalid JSON')
      end

      it 'renders the JSON response error message' do
        post '/search', params: { query: query }, headers: headers

        expect(response).to have_http_status(:unprocessable_entity)
        expect(json['error']).to eq('Invalid JSON response from server, try again.')
        expect(json['metadata']).to have_key('timestamp')
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

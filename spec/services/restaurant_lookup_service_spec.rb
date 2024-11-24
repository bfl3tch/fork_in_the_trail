require 'rails_helper'

RSpec.describe RestaurantLookupService do
  describe '.search', :vcr do
    let(:query) { 'Pizza near Satellite Beach, FL' }

    context 'when the API responds successfully' do
      it 'returns a parsed list of places' do
        response = described_class.search(query)

        expect(response).to be_a(Hash)
        expect(response).to have_key(:places)
        expect(response[:places]).to be_an(Array)
        expect(response[:places].first).to include(
          displayName: be_a(Hash),
          formattedAddress: be_a(String),
          priceLevel: be_a(String)
        )
      end
    end

    context 'when the API responds with an error' do
      before do
        ENV['GOOGLE_PLACES_API_KEY'] = 'incorrect_api_key'
      end

      it 'returns an error hash with the HTTP status and message' do
        response = described_class.search(query)
        error_message = response[:error][:message]
        response_code = response[:error][:code]

        expect(error_message).to eq(
          "API key not valid. Please pass a valid API key."
        )
        expect(response_code).to eq(400)
      end
    end
  end
end

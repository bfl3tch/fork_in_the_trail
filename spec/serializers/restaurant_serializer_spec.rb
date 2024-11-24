RSpec.describe RestaurantSerializer, :vcr do
  let(:query) { 'Pizza near Satellite Beach, FL' }
  let(:mock_response_no_photos) do
    {
      places: [
        {
          displayName: { text: 'No Photo Place' },
          formattedAddress: '123 Imaginary St, Nowhere, USA',
          priceLevel: 'PRICE_LEVEL_INEXPENSIVE'
        }
      ]
    }
  end

    context 'when the place has photos' do
      it 'serializes the photo_url correctly' do
        response = RestaurantLookupService.search(query)
        place_with_photo = response[:places].find { |p| p[:photos].present? }

        serializer = described_class.new(place_with_photo)
        result = serializer.serialize

        expect(result[:photo_url]).to start_with('https://places.googleapis.com/v1/')
        expect(result[:photo_url]).to include('/media?key=')
        expect(result[:photo_url]).to include('maxWidthPx=400')
      end
    end

context 'when the place has no photos' do
    it 'returns nil for photo_url' do
      allow(RestaurantLookupService).to receive(:search).and_return(mock_response_no_photos)

      response = RestaurantLookupService.search(query)
      place_without_photo = response[:places].find { |p| p[:photos].blank? }

      serializer = described_class.new(place_without_photo)
      result = serializer.serialize

      expect(result[:photo_url]).to be_nil
      expect(result[:name]).to eq('No Photo Place')
    end
  end
end
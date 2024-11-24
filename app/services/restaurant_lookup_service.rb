class RestaurantLookupService
  def self.connection
    Faraday.new(url: 'https://places.googleapis.com') do |f|
      f.headers['Content-Type'] = 'application/json'
      f.headers['X-Goog-Api-Key'] = ENV['GOOGLE_PLACES_API_KEY']
      f.headers['X-Goog-FieldMask'] = 'places.id,places.displayName,places.formattedAddress,places.priceLevel,places.photos'
    end
  end

  def self.search(query)
    response = connection.post('/v1/places:searchText') { |request|
      request.body = { textQuery: query }.to_json
    }
    json_response = JSON.parse(response.body, symbolize_names: true)
  end

end

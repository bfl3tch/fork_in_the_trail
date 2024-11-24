class RestaurantSerializer
  def initialize(place, user = nil)
    @place = place
    @user = user
  end

  def serialize
    {
      name: @place.dig(:displayName, :text),
      address: @place[:formattedAddress],
      price_level: convert_price_level(@place[:priceLevel]),
      photo_url: build_photo_url,
      place_id: @place.dig(:id),
      is_favorite: favorite?
    }
  end

  private def convert_price_level(price_level)
    case price_level
      when 'PRICE_LEVEL_INEXPENSIVE' then '$'
      when 'PRICE_LEVEL_MODERATE' then '$$'
      when 'PRICE_LEVEL_EXPENSIVE' then '$$$'
      when 'PRICE_LEVEL_VERY_EXPENSIVE' then '$$$$'
      else 'Unknown'
    end
  end

  private def build_photo_url
    photo_name = @place.dig(:photos, 0, :name)
    return nil unless photo_name
    
    "https://places.googleapis.com/v1/#{photo_name}/media?key=#{ENV['GOOGLE_PLACES_API_KEY']}&maxWidthPx=400"
  end

  private def favorite?
    return false unless @user

    @user.favorites.exists?(restaurant_id: @place.dig(:id))
  end
end

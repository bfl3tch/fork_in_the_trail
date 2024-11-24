class Api::V1::RestaurantsController < ApplicationController
  def search
    response = RestaurantLookupService.search(query_params)
    return handle_service_error(response) if response[:error].present?

    restaurants = response[:places].map { |place| RestaurantSerializer.new(place, current_user).serialize }
    render_with_metadata(restaurants, :ok)
  end

  private def query_params
    params.require(:query)
  end
end

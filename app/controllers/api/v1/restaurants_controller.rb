class Api::V1::RestaurantsController < ApplicationController
  def search
    result = RestaurantLookupService.search(query_params)
    return render_error_with_metadata(result[:error][:message], :bad_request) if result[:error].present?
    return render_error_with_metadata('Nothing found, try again.', :not_found) if result[:places].blank?

    render_with_metadata(serialize_result(result), :ok)
  end

  private def query_params
    params.require(:query)
  end

  private def serialize_result(result)   
    result[:places].map { |place| RestaurantSerializer.new(place, current_user).serialize }
  end
end

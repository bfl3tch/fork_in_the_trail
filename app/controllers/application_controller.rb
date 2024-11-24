class ApplicationController < ActionController::API
  include Authentication
  include ErrorHandler

  def render_with_metadata(result, status)
    render json: { metadata: metadata, result: result }, status: status
  end

  def metadata
    metadata = {
      current_user: current_user&.email,
      timestamp: Time.zone.now
    }
  end
end

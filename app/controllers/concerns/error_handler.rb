class UnauthorizedError < StandardError; end

module ErrorHandler
  extend ActiveSupport::Concern

  included do
    rescue_from ActionDispatch::Http::Parameters::ParseError, with: :handle_parse_error
    rescue_from ActionController::ParameterMissing, with: :handle_param_missing
    rescue_from Faraday::ConnectionFailed, with: :connection_error
    rescue_from UnauthorizedError, with: :handle_unauthorized_error
  end

  private def connection_error
    render_error_with_metadata('Connection issue, please try again.', :unprocessable_entity)
  end

  private def handle_parse_error(_exception)
    render_error_with_metadata('Invalid JSON format', :bad_request)
  end

  private def handle_param_missing(_exception)
    render_error_with_metadata('Query param empty or missing', :bad_request)
  end

  private def handle_unauthorized_error(exception)
    render_error_with_metadata('Unauthorized request', :unauthorized)
  end

  private def handle_service_error(response)
    error_info = JSON.parse(response[:message] || {}).with_indifferent_access
    error_message = error_info.dig(:error, :message) || 'An unknown error occurred'
    status = error_info.dig(:error, :code)&.to_i || 400

    render_error_with_metadata(error_message, status)
  end

  private def render_error_with_metadata(message, status)
    render json: { metadata: metadata, error: message }, status: status
  end
end

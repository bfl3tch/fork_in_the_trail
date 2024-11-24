module Authentication
  extend ActiveSupport::Concern

  included do
    before_action :authenticate_user!
  end 

  private def authenticate_user!
    api_key = request.headers['X-Api-Key']
    @current_user = User.find_by(api_key: api_key)

    raise UnauthorizedError unless @current_user
  end

  private def current_user
    @current_user
  end
end

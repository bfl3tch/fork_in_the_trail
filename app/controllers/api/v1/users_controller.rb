module Api
  module V1
    class UsersController < ApplicationController

      skip_before_action :authenticate_user!, only: [:create]

      def create
        user = User.new(user_signup_params)
        return render_user_errors(user) unless user.save

        render json: UserSerializer.new(user).serializable_hash, status: :created
      end

      private def user_signup_params
        params.require(:user).permit(:email, :password, :password_confirmation)
      end

      def render_user_errors(user)
        render json: { errors: user.errors.full_messages.uniq }, status: :unprocessable_entity
      end
    end
  end
end

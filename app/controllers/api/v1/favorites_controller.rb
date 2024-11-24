class Api::V1::FavoritesController < ApplicationController
  def create
    favorite = current_user.favorites.find_or_initialize_by(favorite_params)

    if favorite.new_record?
      favorite.save!
      render_with_metadata({ message: 'Favorite successfully created', favorite: favorite }, :ok)
    else
      render_with_metadata({ message: 'Favorite already exists', favorite: favorite }, :ok)
    end
  rescue ActiveRecord::RecordInvalid => e
    render_error_with_metadata(e.message, :unprocessable_entity)
  end

  def index
    favorites = current_user.favorites
    render_with_metadata({ favorites: favorites }, :ok)
  end

  private def favorite_params
    { restaurant_id: params.require(:place_id) }
  end
end

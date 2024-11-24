Rails.application.routes.draw do
  post '/search', to: 'api/v1/restaurants#search' # alias for ease of use

  namespace :api do
    namespace :v1 do
      resources :users, only: [:create]
      post 'restaurants/search', to: 'restaurants#search'
    end
  end
end

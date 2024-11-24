Rails.application.routes.draw do
  post '/search', to: 'api/v1/restaurants#search'
  post '/favorites', to: 'api/v1/favorites#create'
  get '/favorites', to: 'api/v1/favorites#index'
  post '/users', to: 'api/v1/users#create'

end

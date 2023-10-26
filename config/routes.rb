Rails.application.routes.draw do
  devise_for :users
  root 'playlists#index'

  resources :playlists, only: %i[show new create edit update destroy]
end

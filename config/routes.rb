Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'users/registrations' }
  root 'playlists#index'

  resources :playlists, only: %i[show new create edit update destroy]
  resources :users, only: %i[show]

  resources :tracks do
    collection do
      get :search
    end
  end
end

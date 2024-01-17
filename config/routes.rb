Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'users/registrations' }
  root 'playlists#index'

  resources :playlists do
    collection do
      post :add_track_to_playlist
    end
  end

  resources :users, only: %i[show]

  resources :tracks do
    collection do
      get :search
    end
  end
end

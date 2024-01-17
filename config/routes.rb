Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'users/registrations' }
  root 'playlists#index'
  
  get 'my_playlists', to: 'playlists#my_playlists', as: :my_playlists, only: %i[show]

  resources :playlists do
    collection do
      post :add_track_to_playlist
    end
    resources :tracks, controller: 'playlist_tracks', only: %i[destroy]
    resources :comments, only: %i[create]
    resources :good_vibes, only: %i[create destroy]
  end

  resources :users, only: %i[show] do
    member do
      get :good_vibes
      get :comments
    end
  end

  resources :tracks do
    collection do
      get :search
    end
  end

end

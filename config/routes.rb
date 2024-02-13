Rails.application.routes.draw do
  devise_for :users, controllers: { 
    registrations: 'users/registrations',
    omniauth_callbacks: 'users/omniauth_callbacks'
  }

  root 'playlists#index'

  get 'about', to: 'static_pages#about'
  get 'terms', to: 'static_pages#terms'
  get 'privacy_policy', to: 'static_pages#privacy_policy'
  get 'update_info', to: 'static_pages#update_info'
  
  get 'my_playlists', to: 'playlists#my_playlists', as: :my_playlists, only: %i[show]
  get 'trend_picks', to: 'playlists#trend_picks', as: :trend_picks, only: %i[show]

  resources :playlists do
    collection do
      get :new_releases
      post :add_track_to_playlist
      delete :remove_track_from_playlist
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

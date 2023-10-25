Rails.application.routes.draw do
  devise_for :users
  root 'playlists#index'
end

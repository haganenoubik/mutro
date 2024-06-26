class AddSpotifyColumnsToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :spotify_token, :string
    add_column :users, :spotify_refresh_token, :string
    add_column :users, :spotify_token_expires_at, :datetime
  end
end

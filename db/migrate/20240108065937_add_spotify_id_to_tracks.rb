class AddSpotifyIdToTracks < ActiveRecord::Migration[7.0]
  def change
    add_column :tracks, :spotify_id, :string
  end
end

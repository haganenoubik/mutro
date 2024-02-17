class AddMoodToPlaylists < ActiveRecord::Migration[7.0]
  def change
    add_reference :playlists, :mood, null: true, foreign_key: true
  end
end

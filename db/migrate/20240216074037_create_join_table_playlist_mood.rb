class CreateJoinTablePlaylistMood < ActiveRecord::Migration[7.0]
  def change
    create_join_table :playlists, :moods do |t|
      # t.index [:playlist_id, :mood_id]
      # t.index [:mood_id, :playlist_id]
    end
  end
end

class DropJoinTablePlaylistMood < ActiveRecord::Migration[7.0]
  def change
    drop_join_table :playlists, :moods
  end
end

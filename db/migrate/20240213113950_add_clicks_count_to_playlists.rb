class AddClicksCountToPlaylists < ActiveRecord::Migration[7.0]
  def change
    add_column :playlists, :clicks_count, :integer, default: 0
  end
end

class AddImageUrlToTracks < ActiveRecord::Migration[7.0]
  def change
    add_column :tracks, :image_url, :string
  end
end

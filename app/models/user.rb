class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :playlists, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :good_vibes, dependent: :destroy


  # 特定のプレイリストに対してGood Vibesの有無を確認
  def good_vibed?(playlist)
    good_vibes.exists?(playlist_id: playlist.id)
  end

  # 特定のプレイリストに対するGood Vibesを取得
  def good_vibe_for(playlist)
    good_vibes.find_by(playlist_id: playlist.id)
  end
end

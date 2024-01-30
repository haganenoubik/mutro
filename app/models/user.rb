class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: %i[google_oauth2]

  has_many :playlists, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :good_vibes, dependent: :destroy
  has_many :good_vibed_playlists, through: :good_vibes, source: :playlist

  def self.from_omniauth(auth)
    user = User.where(email: auth.info.email).first

    if user
      # ユーザーが既に存在する場合、プロバイダとUIDを更新
      user.provider = auth.provider
      user.uid = auth.uid
      user.save
    else
      # ユーザーが存在しない場合、新しく作成
      user = User.create(
        name: auth.info.name,
        email: auth.info.email,
        password: Devise.friendly_token[0, 20],
        provider: auth.provider,
        uid: auth.uid
      )
    end

    user
  end

  # 特定のプレイリストに対してGood Vibesの有無を確認
  def good_vibed?(playlist)
    good_vibes.exists?(playlist_id: playlist.id)
  end

  # 特定のプレイリストに対するGood Vibesを取得
  def good_vibe_for(playlist)
    good_vibes.find_by(playlist_id: playlist.id)
  end
end

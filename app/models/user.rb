class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: %i[google_oauth2 spotify]

  has_many :playlists, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :good_vibes, dependent: :destroy
  has_many :good_vibed_playlists, through: :good_vibes, source: :playlist

  def self.from_omniauth(auth)
    user = User.where(email: auth.info.email).first_or_initialize do |u|
      u.email = auth.info.email
      u.password = Devise.friendly_token[0, 20] if u.encrypted_password.blank?
      u.name = auth.info.name if u.name.blank?
    end

    user.update(
      provider: auth.provider,
      uid: auth.uid,
      spotify_token: auth.credentials.token,
      spotify_refresh_token: auth.credentials.refresh_token,
      spotify_token_expires_at: Time.at(auth.credentials.expires_at)
    )

    user
  end

  def spotify_user
    credentials = {
      'token' => spotify_token,
      'refresh_token' => spotify_refresh_token,
      'access_refresh_callback' => Proc.new { |new_access_token, token_lifetime|
        update(
          spotify_token: new_access_token,
          spotify_token_expires_at: Time.now + token_lifetime
        )
      }
    }

    RSpotify::User.new('credentials' => credentials, 'id' => uid)
  end

  def good_vibed?(playlist)
    good_vibes.exists?(playlist_id: playlist.id)
  end

  def good_vibe_for(playlist)
    good_vibes.find_by(playlist_id: playlist.id)
  end
end

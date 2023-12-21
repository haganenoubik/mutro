require_relative "boot"

require "rails/all"

Bundler.require(*Rails.groups)

module Mutro
  class Application < Rails::Application
    config.load_defaults 7.0
    config.i18n.default_locale = :ja

    # Spotify APIの認証情報を設定
    RSpotify::authenticate(ENV['SPOTIFY_CLIENT_ID'], ENV['SPOTIFY_CLIENT_SECRET'])
  end
end

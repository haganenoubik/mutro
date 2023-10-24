require_relative "boot"

require "rails/all"

Bundler.require(*Rails.groups)

module Mutro
  class Application < Rails::Application
    config.load_defaults 7.0
    config.i18n.default_locale = :ja
  end
end

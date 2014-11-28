require File.expand_path('../boot', __FILE__)

require 'rails/all'

Bundler.require(*Rails.groups)

module Prelaunchr
  class Application < Rails::Application
    # Configure the default encoding used in templates for Ruby 1.9.
    config.encoding = "utf-8"

    config.assets.paths << Rails.root.join('app', 'assets', 'fonts')
    config.ended = false
    config.middleware.use Rack::Deflater
  end
end

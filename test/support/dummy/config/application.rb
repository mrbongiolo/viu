require_relative 'boot'

require "active_model/railtie"
require "action_controller/railtie"
require "action_view/railtie"
require "sprockets/railtie"

require "viu"

require "haml"
require "slim"

module Dummy
  class Application < Rails::Application
    config.paths['app/views'].eager_load!
  end
end

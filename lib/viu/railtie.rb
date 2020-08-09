# frozen_string_literal: true

require "rails"
require "viu/rendering_helpers"

module Viu
  class Railtie < Rails::Railtie

    initializer "viu.include_rendering_helpers" do |app|
      ActiveSupport.on_load(:action_view) do
        ActionView::Base.include Viu::RenderingHelpers::ActionViewHelpers
      end

      ActiveSupport.on_load(:action_controller) do
        ActionController::Base.include Viu::RenderingHelpers::ActionControllerHelpers
      end
    end
  end
end

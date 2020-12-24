# frozen_string_literal: true

module Viu
  module RenderingHelpers
    module ActionViewHelpers
      def render_view(view, options = EMPTY_HASH)
        view.render_in(@view_context, options)
      end
    end

    module ActionControllerHelpers
      def render_view(view, options = EMPTY_HASH)
        format = options.fetch(:format) { :html }
        render(format => view.render_in(view_context, options))
      end
    end
  end
end

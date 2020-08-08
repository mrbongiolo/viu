# frozen_string_literal: true

require "viu/html"

module Viu
  class Layout < Html

    class Renderer < ActionView::PartialRenderer

      # https://github.com/rails/rails/blob/v5.2.4.3/actionview/lib/action_view/renderer/partial_renderer.rb#L421
      def find_template(path, locals)
        prefixes = path.include?(?/) ? [] : @lookup_context.prefixes
        # just override partial arg to false, so that it will look for templates without a prefixed _
        @lookup_context.find_template(path, prefixes, false, locals, @details)
      end
    end

    def render_in(view_context, &block)
      __setup!(view_context)

      Renderer.new(@lookup_context).render(self, { partial: __fetch_template!, layout: nil }, block)
    end
  end
end

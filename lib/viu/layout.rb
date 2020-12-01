# frozen_string_literal: true

require "viu/html"

module Viu
  class Layout < Html

    class Renderer < ActionView::PartialRenderer

      # https://github.com/rails/rails/blob/v5.2.4.3/actionview/lib/action_view/renderer/partial_renderer.rb#L421
      def find_template(path, locals)
        prefixes = path.include?(?/) ? [] : @lookup_context.prefixes
        # override partial arg to false, so that it will look for templates without a prefixed _
        @lookup_context.find_template(path, prefixes, false, locals, @details)
      end
    end

    RAILS_6_0 = Gem::Version.new('6.0.0')
    RAILS_6_1_WITH_PRERELEASES = Gem::Version.new('6.1.0.a')
    private_constant :RAILS_6_0, :RAILS_6_1_WITH_PRERELEASES

    def render_in(view_context, &block)
      __setup!(view_context)

      rails_version = ::Rails.gem_version

      if rails_version >= RAILS_6_1_WITH_PRERELEASES
        Renderer.new(@lookup_context, layout: nil).render(__fetch_template!, self, block).body
      elsif rails_version >= RAILS_6_0
        Renderer.new(@lookup_context).render(self, { partial: __fetch_template!, layout: nil }, block).body
      else
        Renderer.new(@lookup_context).render(self, { partial: __fetch_template!, layout: nil }, block)
      end
    end
  end
end

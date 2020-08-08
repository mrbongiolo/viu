# frozen_string_literal: true

require "action_view"

module Viu
  class Html < ActionView::Base

    def initialize(*); end

    def render_in(view_context, options = EMPTY_HASH)
      __setup!(view_context)

      layout = options.fetch(:layout, self.class.layout)

      if layout.is_a?(Class)
        __render_layout_class(layout)
      elsif layout.is_a?(Proc)
        __render_layout_proc(layout)
      else
        @view_renderer.render(self, template: __fetch_template!, layout: layout)
      end
    end

    private

    attr_reader :controller, :request

    delegate :protect_against_forgery?, :form_authenticity_token, :content_security_policy?, to: :helpers

    def helpers
      @helpers ||= controller.view_context
    end

    def render_view(view, options = EMPTY_HASH)
      render(html: view.render_in(@view_context, options))
    end

    def __setup!(view_context)
      @view_context = view_context
      @lookup_context ||= view_context.lookup_context
      @view_renderer ||= view_context.view_renderer
      @controller ||= view_context.controller
      @request ||= controller.request
      _prepare_context
    end

    def __fetch_template!
      return self.class.template if self.class.template.present?

      self.class.template!(self.class.name.underscore)
    end

    def __render_layout_class(layout)
      layout.new.render_in(@view_context) do
        @view_renderer.render(self, template: __fetch_template!, layout: nil)
      end
    end

    def __render_layout_proc(layout)
      self.instance_exec(&layout).render_in(@view_context) do
        @view_renderer.render(self, template: __fetch_template!, layout: nil)
      end
    end

    class << self

      def inherited(child)
        if defined?(Rails) && child != Viu::Layout
          child.include Rails.application.routes.url_helpers unless child < Rails.application.routes.url_helpers
        end
      end

      def layout!(value)
        @__layout = value
      end

      def layout
        @__layout ||= nil
      end

      def template!(value)
        @__template = value
      end

      def template
        @__template ||= nil
      end
    end
  end
end

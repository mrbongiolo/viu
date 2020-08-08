# frozen_string_literal: true

module Viu
  module TestHelpers

    attr_reader :rendered_view

    def render_view(view, **args)
      @rendered_view = Nokogiri::HTML::Document.parse(
        view.render_in(controller.view_context, args)
      )
    end

    def controller
      # TODO: make ApplicationController usage here configurable
      @controller ||= ApplicationController.new.tap { |c| c.request = request }
        .extend(Rails.application.routes.url_helpers)
    end

    def request
      @request ||= ActionDispatch::TestRequest.create
    end

    private

    def document_root_element
      @rendered_view.root
    end
  end
end

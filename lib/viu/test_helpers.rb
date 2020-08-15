# frozen_string_literal: true

require 'active_support/concern'
require 'active_support/inflector'
require 'active_support/core_ext/class/attribute'

module Viu
  module TestHelpers
    extend ActiveSupport::Concern

    private

    attr_reader :view_instance, :raw_rendered_view, :rendered_view

    def render_view(view, **args)
      @rendered ||= []
      @view_instance = view
      @raw_rendered_view = @view_instance.render_in(__controller.view_context, **args)
      @rendered << @raw_rendered_view
      @rendered_view = Nokogiri::HTML::Document.parse(@raw_rendered_view)
    end

    def __controller
      @__controller ||= __constantize(self.class.__controller_class).new.tap do |c|
        c.request = request
        c.action_name = 'show'
      end
        .extend(Rails.application.routes.url_helpers)
    end

    def request
      @request ||= ActionDispatch::TestRequest.create
    end

    def __constantize(value)
      return value if value.is_a?(Class)

      ActiveSupport::Inflector.constantize(value)
    end

    included do
      class_attribute :__controller_class, instance_accessor: false, instance_predicate: false,
        default: 'ApplicationController'
    end

    class_methods do

      def controller_class(klass)
        self.__controller_class = klass
      end
    end
  end
end

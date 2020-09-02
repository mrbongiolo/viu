# frozen_string_literal: true

require 'active_support/concern'
require 'active_support/core_ext/class/attribute'

module Viu
  module Json
    extend ActiveSupport::Concern

    DEFAULT_JSON_ENCODER = ->(input) { input.to_json }.freeze

    included do
      class_attribute :__json_encoder, instance_accessor: false, instance_predicate: false,
        default: DEFAULT_JSON_ENCODER

      attr_reader :rendering_options

      def to_json(options = EMPTY_HASH)
        @rendering_options = options
        self.class.__json_encoder.call(json_output)
      end
    end

    class_methods do

      def json_encoder(value)
        self.__json_encoder = value
      end
    end
  end
end

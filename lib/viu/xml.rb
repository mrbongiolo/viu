# frozen_string_literal: true

require 'active_support/concern'
require 'active_support/core_ext/class/attribute'

module Viu
  module Xml
    extend ActiveSupport::Concern

    DEFAULT_XML_ENCODER = ->(input) { input.to_xml }.freeze

    included do
      class_attribute :__xml_encoder, instance_accessor: false, instance_predicate: false,
        default: DEFAULT_XML_ENCODER

      attr_reader :rendering_options

      def to_xml(options = EMPTY_HASH)
        @rendering_options = options
        self.class.__xml_encoder.call(xml_output)
      end
    end

    class_methods do

      def xml_encoder(value)
        self.__xml_encoder = value
      end
    end
  end
end

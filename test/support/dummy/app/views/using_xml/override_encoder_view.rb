# frozen_string_literal: true

require "oj"

module UsingXml
  class OverrideEncoderView < UsingXml::ApplicationView

    xml_encoder ->(input) {
      input.merge(with: "not really another encoder").to_xml
    }

    def initialize(title:)
      @title = title
    end

    private

    def xml_output
      { title: @title }
    end
  end
end

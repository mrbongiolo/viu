# frozen_string_literal: true

require "oj"

module UsingJson
  class OverrideEncoderView < UsingJson::ApplicationView

    json_encoder ->(input) {
      Oj.dump(input.merge(with: "oj"), mode: :compat)
    }

    def initialize(title:)
      @title = title
    end

    private

    def json_output
      { title: @title }
    end
  end
end

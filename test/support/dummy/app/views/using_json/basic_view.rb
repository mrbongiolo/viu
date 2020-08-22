# frozen_string_literal: true

module UsingJson
  class BasicView < UsingJson::ApplicationView

    private

    def json_output
      { rendering_options: rendering_options }
    end
  end
end

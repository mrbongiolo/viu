# frozen_string_literal: true

module UsingXml
  class BasicView < UsingXml::ApplicationView

    private

    def xml_output
      { rendering_options: rendering_options }
    end
  end
end

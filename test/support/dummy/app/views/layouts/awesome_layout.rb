# frozen_string_literal: true

module Layouts
  class AwesomeLayout < Viu::Layout
    layout! nil

    attr_reader :header

    def initialize(header: 'HEADER')
      @header = header
    end
  end
end

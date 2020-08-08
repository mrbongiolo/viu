# frozen_string_literal: true

class ViuLayoutOverrideView < ApplicationView
  layout! Proc.new { Layouts::AwesomeLayout.new(header: "a different header") }
end

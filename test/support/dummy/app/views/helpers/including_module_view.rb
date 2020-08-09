# frozen_string_literal: true

module Helpers
  class IncludingModuleView < ApplicationView
    include JustAModuleWithMethods
  end
end

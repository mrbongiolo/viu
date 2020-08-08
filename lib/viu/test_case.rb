# frozen_string_literal: true

require "active_support/test_case"
require "rails/dom/testing/assertions"
require "viu/test_helpers"

module Viu
  class TestCase < ActiveSupport::TestCase
    include Rails::Dom::Testing::Assertions
    include Viu::TestHelpers
  end
end

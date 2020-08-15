# frozen_string_literal: true

require "action_view/test_case"
require "rails/dom/testing/assertions"
require "viu/test_helpers"

module Viu
  class TestCase < ActionView::TestCase
    include Rails::Dom::Testing::Assertions
    include Viu::TestHelpers
  end
end

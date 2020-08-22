# frozen_string_literal: true

require "viu/version"

require "viu/html"
require "viu/layout"
require "viu/json"
require "viu/xml"
require "viu/test_case"

require 'viu/railtie' if defined?(Rails)

module Viu
  EMPTY_HASH = {}.freeze

  class Error < StandardError; end
end

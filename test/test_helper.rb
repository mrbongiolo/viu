# frozen_string_literal: true

require "simplecov"
SimpleCov.start

# $LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
# require "viu"

require "minitest/pride"
require "minitest/autorun"

ENV["RAILS_ENV"] = "test"

require File.expand_path("../support/dummy/config/environment.rb", __FILE__)
require "rails/test_help"

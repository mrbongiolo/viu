# frozen_string_literal: true

# disable ruby warnings:
# https://fuzzyblog.io/blog/rails/2020/01/28/turning-off-ruby-deprecation-warnings-when-running-tests.html
$VERBOSE=nil

require "simplecov"
SimpleCov.start

# $LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
# require "viu"

require "minitest/pride"
require "minitest/autorun"

ENV["RAILS_ENV"] = "test"

require File.expand_path("../support/dummy/config/environment.rb", __FILE__)
require "rails/test_help"

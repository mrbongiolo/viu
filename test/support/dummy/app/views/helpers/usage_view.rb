# frozen_string_literal: true

module Helpers
  class UsageView < ApplicationView

    def post
      @post ||= Post.new(title: "New title")
    end
  end
end

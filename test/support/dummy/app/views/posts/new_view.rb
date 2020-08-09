# frozen_string_literal: true

module Posts
  class NewView < ApplicationView

    attr_reader :post

    def initialize(post:)
      @post = post
    end
  end
end

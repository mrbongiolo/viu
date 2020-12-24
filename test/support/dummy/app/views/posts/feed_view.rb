# frozen_string_literal: true

module Posts
  class FeedView < ApplicationView

    layout! nil

    def initialize(posts:)
      @posts = posts
    end

  end
end

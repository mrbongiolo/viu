# frozen_string_literal: true

module Posts
  class IndexView < ApplicationView

    layout! Layouts::AwesomeLayout

    def initialize(posts:)
      @posts = posts
    end

    def render_header_view
      render_view Index::HeaderView.new
    end
  end
end

# frozen_string_literal: true

module Posts
  class ShowView < ApplicationView
    include Viu::Json
    include Viu::Xml

    template! -> { tag.h1 title_upcase }

    def initialize(post:)
      @post = post
    end

    private

    def title_upcase
      @post.title.upcase
    end

    def json_output
      { title: title_upcase }
    end

    def xml_output
      json_output
    end
  end
end

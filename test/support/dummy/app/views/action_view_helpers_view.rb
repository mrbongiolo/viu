# frozen_string_literal: true

class ActionViewHelpersView < ApplicationView

  def post
    @post ||= Post.new(title: "New title")
  end
end

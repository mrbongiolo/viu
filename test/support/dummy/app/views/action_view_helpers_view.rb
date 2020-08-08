# frozen_string_literal: true

class ActionViewHelpersView < ApplicationView
  layout! nil

  def post
    @post ||= Post.new(title: "New title")
  end
end

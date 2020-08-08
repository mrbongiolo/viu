# frozen_string_literal: true

class HomeController < ApplicationController

  def index
    render_view ViewViuLayout.new
  end
end

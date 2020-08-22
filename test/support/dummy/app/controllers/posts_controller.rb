# frozen_string_literal: true

class PostsController < ApplicationController

  def index
    render_view Posts::IndexView.new(posts: posts)
  end

  def show
    post = ::Post.new(title: 'A Title')
    respond_to do |format|
      format.html { render_view Posts::ShowView.new(post: post) }
      format.json { render json: Posts::ShowView.new(post: post) }
      format.xml { render xml: Posts::ShowView.new(post: post) }
    end
  end

  def new
    @not_available_for_view = ::Post.new(title: 'Not available')
    render_view Posts::NewView.new(post: ::Post.new)
  end

  def create
    post = ::Post.new(post_params)
    if post.valid?
      redirect_to posts_path, notice: "Successfully saved your awesome post!"
    else
      flash[:alert] = "There was an error"
      render_view Posts::NewView.new(post: post)
    end
  end

  private

  def posts
    @posts ||= [::Post.new(title: 'First'), ::Post.new(title: 'Second')]
  end

  def post_params
    params.require(:post).permit(:title)
  end
end

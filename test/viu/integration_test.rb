# frozen_string_literal: true

require "test_helper"

class IntegrationTest < ActionDispatch::IntegrationTest

  test "rendering a view from a controller" do
    get "/posts"
    assert_response :success

    assert_select("h1", "Posts - IndexView")
    assert_select("li a", count: 2)
  end

  test "view does not have access to controller @ivars" do
    get "/posts/new"
    assert_response :success

    assert_select("h1", "Posts - NewView")
    assert_select("span.alert", false)
    assert_select("ul.errors li", false)
    assert_select(".not-available", "nil")
  end

  test "rendering a model with errors" do
    post "/posts", params: { post: { title: "" } }
    assert_response :success

    assert_select("h1", "Posts - NewView")
    assert_select("span.alert", "There was an error")
    assert_select("ul.errors li", "Title can't be blank")
  end

  test "access flash after successful create" do
    post "/posts", params: { post: { title: "A Title" } }
    assert_response :redirect

    follow_redirect!

    assert_select("h1", "Posts - IndexView")
    assert_select(".flash.notice", "Successfully saved your awesome post!")
  end
end

# frozen_string_literal: true

require "test_helper"

ActionDispatch::IntegrationTest.register_encoder :xml

class IntegrationTest < ActionDispatch::IntegrationTest

  test "rendering a view from a controller" do
    get "/posts"
    assert_response :success

    assert_select("h1", "Posts - IndexView")
    assert_select("li a", count: 2)

    assert_equal("text/html", controller.rendered_format)
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

  test "rendering with HTML format" do
    get "/posts/1", as: :html
    assert_response :success

    assert_equal('<h1>A TITLE</h1>', response.parsed_body)
  end

  test "rendering with JSON format" do
    get "/posts/1", as: :json
    assert_response :success

    assert_equal({ 'title' => 'A TITLE' }, response.parsed_body)
  end

  test "rendering with XML format" do
    get "/posts/1", as: :xml
    assert_response :success

    assert_equal({ title: 'A TITLE' }.to_xml, response.parsed_body)
  end
end

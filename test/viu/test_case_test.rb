# frozen_string_literal: true

require "test_helper"

class TestCaseTest < Viu::TestCase

  controller_class PostsController

  def test_can_override_controller_class
    render_view(NoLayoutView.new)

    assert_equal(PostsController, view_instance.controller.class)
  end
end

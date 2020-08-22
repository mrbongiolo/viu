# frozen_string_literal: true

require "test_helper"

class JsonTest < Viu::TestCase

  def test_has_access_to_rendering_options
    result = UsingJson::BasicView.new.to_json(foo: "bar")
    assert_equal({ rendering_options: { foo: "bar" } }.to_json, result)
  end

  def test_allow_override_encoder
    result = UsingJson::OverrideEncoderView.new(title: "Overridden").to_json({})
    assert_equal({ title: "Overridden", with: "oj" }.to_json, result)
  end

  def test_can_be_used_with_xml_and_html_view
    result = Posts::ShowView.new(post: ::Post.new(title: 'title')).to_json({})
    assert_equal({ title: 'TITLE' }.to_json, result)
  end
end

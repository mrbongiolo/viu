# frozen_string_literal: true

require "test_helper"

class XmlTest < Viu::TestCase

  def test_has_access_to_rendering_options
    result = UsingXml::BasicView.new.to_xml(foo: "bar")
    assert_equal({ rendering_options: { foo: "bar" } }.to_xml, result)
  end

  def test_allow_override_encoder
    result = UsingXml::OverrideEncoderView.new(title: "Overridden").to_xml({})
    assert_equal({ title: "Overridden", with: "not really another encoder" }.to_xml, result)
  end

  def test_can_be_used_with_json_and_html_view
    result = Posts::ShowView.new(post: ::Post.new(title: 'title')).to_xml({})
    assert_equal({ title: 'TITLE' }.to_xml, result)
  end
end

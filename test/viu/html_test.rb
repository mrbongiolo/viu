# frozen_string_literal: true

require "test_helper"

class HtmlTest < Viu::TestCase

  def test_it_inherits_from_action_view_base
    assert_equal(ActionView::Base, Viu::Html.superclass)
  end

  def test_renders_without_a_layout
    render_view(NoLayoutView.new)

    assert_select('header', false)
    assert_select('h1', 'View no layout')
  end

  def test_renders_with_template_layout
    render_view(TemplateLayoutView.new)

    assert_select('header', 'Layout Header')
    assert_select('h1', 'View template layout')
  end

  def test_renders_with_viu_layout
    render_view(ViuLayoutView.new)

    assert_select('header', 'HEADER')
    assert_select('h1', 'View viu layout')
  end

  def test_renders_with_viu_layout_overriding_attributes
    render_view(ViuLayoutOverrideView.new)

    assert_select('header', 'a different header')
    assert_select('h1', 'View viu layout override')
  end

  def test_renders_template_layout_with_content_for
    render_view(TemplateLayoutView.new)

    assert_select('span', 'breadcrumb')
  end

  def test_does_not_render_content_for_with_viu_layout
    render_view(ViuLayoutView.new)

    assert_select('span', false, 'breadcrumb')
  end

  def test_renders_view_from_layout
    render_view(ViuLayoutView.new)

    assert_select('footer', 'Awesome Layout - Footer View')
  end

  def test_renders_haml_template
    render_view(HamlView.new)

    assert_select('h1', 'View with HAML')
  end

  def test_renders_slim_template
    render_view(SlimView.new)

    assert_select('h1', 'View with slim')
  end

  def test_view_has_url_helpers
    render_view(UrlHelpersView.new)

    assert_select('a[href="/"]')
  end

  def test_view_has_action_view_helpers
    render_view(ActionViewHelpersView.new)

    assert_select('form')
    assert_select('input#post_title', value: 'New title')
    assert_select('p.number-to-currency', '$100,000.00')
    assert_select('img.image_tag')
  end
end

# frozen_string_literal: true

require "test_helper"

class HtmlTest < Viu::TestCase

  def test_it_inherits_from_action_view_base
    assert_equal(ActionView::Base, Viu::Html.superclass)
  end

  def test_default_controller_in_tests_is_application_controller
    render_view(NoLayoutView.new)

    assert_equal(ApplicationController, view_instance.controller.class)
  end

  # Rendering

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

  def test_renders_haml_layout
    render_view(HamlLayoutView.new)

    assert_select('header', 'header from HAML')
  end

  def test_renders_slim_template
    render_view(SlimView.new)

    assert_select('h1', 'View with slim')
  end

  def test_renders_slim_layout
    render_view(SlimLayoutView.new)

    assert_select('header', 'header from SLIM')
  end

  def test_renders_partials
    render_view(PartialsView.new)

    assert_select('div', 'this is a partial')
    assert_select('div', 'in folder partial')
  end

  def test_renders_template_in_custom_location
    render_view(CustomLocationTemplateView.new)

    assert_select('h1', 'not the default location template')
  end

  def test_renders_template_as_a_proc
    render_view(Posts::ShowView.new(post: ::Post.new(title: 'most amazing')))

    assert_select('h1', 'MOST AMAZING')
  end

  # Helpers

  def test_view_has_url_helpers
    render_view(Helpers::UsageView.new)

    assert_select('a[href="/posts"]')
    assert_select('form')
    assert_select('input#post_title', value: 'New title')
    assert_select('p.number-to-currency', '$100,000.00')
    assert_select('img.image_tag')
  end

  def test_view_has_access_to_included_helpers
    render_view(Helpers::UsingIncludeView.new)

    assert_select('div', 'very useful, such greatness')
  end

  def test_view_has_access_to_app_helpers
    render_view(Helpers::UsingHelpersMethodView.new)

    assert_select('div', 'very useful, such greatness')
  end

  def test_view_including_module
    render_view(Helpers::IncludingModuleView.new)

    assert_select('div', 'included was I in this view')
  end
end

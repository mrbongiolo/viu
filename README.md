# Viu

Rails' missing View layer.

## Installation

Add this line to your application's Gemfile:

```ruby
gem "viu"
```

And then execute:

```bash
$ bundle install
```

Or install it yourself as:

```bash
$ gem install viu
```

## Rails Setup

Add this to your `config/application.rb` file:

```ruby
config.eager_load_paths << Rails.root.join("app/views")
```

This will add the `app/views` folder to the eager load paths, as it is not loaded there by default.

## Viu::Html

Probably the most common view type of the wild web lands.

### Usage

`app/views/home_view.rb`:
```ruby
class AwesomeView < Viu::Html

  layout! Layouts::ApplicationLayout

  def initialize(posts:)
    @posts = posts
  end

  private

  def power_level_class(power)
    return "over-9000" if power > 9000

    "not-awesome-enough"
  end
end
```

`app/views/awesome_view.html.erb`:
```erb
<h1>Awesomesauce</h1>
<%- @posts.each do |post| %>
  <article class="<%= power_level_class(post.awesomeness) %>">
    <h1><%= link_to post.title, post, class: "awesome-title" %></h1>
    <p><%= post.summary %></p>
  </article>
<%- end %>
```

`app/controllers/home_controller.rb`:
```ruby
# GET /awesome
def awesome
  posts = Post.order(awesomeness: :desc)
  render_view AwesomeView.new(posts: posts)
end
```

Unless a template is given directly (using the `template! "file"` option inside the view), a view will try to find a
template with it's name.

As seen in the example above a view's template has access to all instance variables, public and private methods defined
in the view, as well as all `ActionView` helpers.

Also, the view won't have access to any variables or instance variables defined in the controller, those have to be
passed in directly, as shown in `AwesomeView.new(posts: posts)`.

### Layouts

By default a view won't be rendered inside a layout. To use a layout, one has to be declared, either directly on the
view or passed to the `render_view` method.

#### Defining a layout template

```ruby
class MyView < Viu::Html

  # This will look for an application template inside app/views/layouts,
  # it can be a html.erb or any other template language defined in your application
  layout! 'layouts/application'
end
```

`app/views/layouts/application.html.erb`:
```erb
<html>
  <head>
    <title>A view view a Layout</title>
    <%= stylesheet_link_tag "application" %>
    <%= javascript_include_tag "application" %>
  </head>
  <body>
    <header>Header from the layout</header>
    <%= yield %>
  </body>
</html>
```

#### Defining a layout view

A layout can also be a `Viu::Layout` class, in this case it will work pretty much like a `Viu::Html`.

```ruby
class MyView < Viu::Html

  layout! ::Layouts::ApplicationLayout
end
```

`app/views/layouts/application_layout.rb`:
```ruby
module Layouts
  # a layout needs to inherit from Viu::Layout
  class ApplicationLayout < Viu::Layout

    private def header_text
      "This is a Viu::Layout"
    end
  end
end
```

`app/views/layouts/application_layout.html.erb`:
```erb
<html>
  <head>
    <title>A Viu::Layout</title>
    <%= stylesheet_link_tag "application" %>
    <%= javascript_include_tag "application" %>
  </head>
  <body>
    <header><%= header_text %></header>
    <%= yield %>
  </body>
</html>
```

Similar as the `Viu::Html` a layout will search for a template with it's name, if none is given directly.

## Known Issues

* A `Viu::Layout` doesn't work with `content_for` blocks, it's only available when using a regular layout template for now
* Templates and partials require the "full" path, eg: `layouts/application` or `posts/index`.

## About

Inspired by `view_component`, `cells` and others, currently this is a POC (proof of concept) to create a View layer
for Rails, it uses `ActionView` as the base for HTML views and it aims to work with the least amount of surprises on a
Rails application, but with a few boundaries, like a View won't be able to automatically access `@ivars` defined
in a controller, those have to explicitly be passed to them.

The project is already been tested on a small scale in our production environment.

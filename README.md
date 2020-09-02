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

`app/views/awesome_view.rb`:
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

### ApplicationView

Usually it's a common practice in rails projects to define an `ApplicationController` or `ApplicationRecord` base class
that can be inherited from. The same can be done with views, an `ApplicationView` class is a good place to put some
basic functionalities that should be available to all views.

### Callable templates

A view's template can be overridden with a `proc`. __Attention:__ currently using a callable template doesn't work with
layouts, they will be ignored.

```ruby
# defining the view
class HeaderView < ApplicationView

  template! proc { tag.h1 @title }

  def initialize(title:)
    @title = title
  end
end

# rendering the view
render_view HeaderView.new(title: "Mas Gente!") # => "<h1>Mas Gente!</h1>"
```

### Layouts

By default a view won't be rendered inside a layout. To use a layout, one has to be declared, either directly on the
view or passed to the `render_view` method.

#### Defining a layout template

`app/views/my_view.rb`:
```ruby
class MyView < ApplicationView
  # This will look for an application template inside app/views/layouts,
  # it can be a html.erb or any other template language defined in your application.
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

`app/views/my_view.rb`:
```ruby
class MyView < ApplicationView
  layout! Layouts::ApplicationLayout
end
```

`app/views/layouts/application_layout.rb`:
```ruby
module Layouts

  # a layout needs to inherit from Viu::Layout
  class ApplicationLayout < Viu::Layout

    def header_text
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

#### Defining a layout `proc`

A layout can also be declared as a `proc`, this is useful when the view wants to override the layout parameters.
The `proc` will be executed in the context of the view and the result must respond to `render_in`.

`app/views/my_view.rb`:
```ruby
class MyView < ApplicationView

  layout! proc { Layouts::ApplicationLayout.new(header_text: text) }

  private

  def text
    "Text from the view"
  end
end
```

`app/views/layouts/application_layout.rb`:
```ruby
module Layouts
  class ApplicationLayout < Viu::Layout

    attr_reader :header_text

    def initialize(header_text: 'The header text')
      @header_text = header_text
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
    <header>
      <!-- it will render "Text from the view" here -->
      <%= header_text %>
    </header>
    <%= yield %>
  </body>
</html>
```

#### Overriding layout on `render_view`

Usually a `layout` is defined directly in the view, as most of the times a view will be used in a single "context",
but if needed it can be overridden on the `render_view` with the `layout:` option, like so:

```ruby
# it accepts a template
render_view MyView.new, layout: 'layouts/admin'

# a Viu::Layout
render_view MyView.new, layout: Layouts::OtherLayout

# or a proc
render_view MyView.new, layout: proc { Layouts::OtherLayout.new(title: 'Dashboard') }
```

## Viu::Json

This is a simple module that can be included in your views, it will add a `to_json` method, this is called by default
when rendering in a Rails env. The value returned from `json_output` will be the output of the view.

`app/views/api/posts/resource_view.rb`:
```ruby
module Api
  module Posts
    class ResourceView
      include Viu::Json

      def initialize(post:)
        @post = post
      end

      private

      def author
        @author ||= @post.author
      end

      def json_output
        {
          title: @post.title,
          published_on: @post.published_on.to_s(:iso8601),
          author: {
            name: author.name,
            avatar: author.avatar.url
          }
        }
      end
    end
  end
end
```

`app/controllers/api/posts_controller.rb`:
```ruby
def show
  post = Post.find(params[:id])
  render json: Api::Posts::ResourceView.new(post: post)
end
```

The default `JSON` encoder can be overridden like so:

```ruby
class MyJsonView
  include Viu::Json

  json_encoder ->(input) { Oj.dump(input) }

end
```

## Viu::Xml

Similar to `Viu::Json` this is a simple module that can be included in your views, it will add a `to_xml` method,
this is called by default when rendering in a Rails env. The value returned from `xml_output` will be the output
of the view.

`app/views/api/posts/resource_view.rb`:
```ruby
module Api
  module Posts
    class ResourceView
      include Viu::Xml

      def initialize(post:)
        @post = post
      end

      private

      def author
        @author ||= @post.author
      end

      def xml_output
        {
          title: @post.title,
          published_on: @post.published_on.to_s(:iso8601),
          author: {
            name: author.name,
            avatar: author.avatar.url
          }
        }
      end
    end
  end
end
```

`app/controllers/api/posts_controller.rb`:
```ruby
def show
  post = Post.find(params[:id])
  render xml Api::Posts::ResourceView.new(post: post)
end
```

The default `XML` encoder can be overridden like so:

```ruby
class MyXmlView
  include Viu::Xml

  xml_encoder ->(input) { Ox.dump(input) }

end
```

## Known Issues

* A `Viu::Layout` doesn't work with `content_for` blocks, it's only available on a regular layout template for now;
* Templates and partials require the "full" path, eg: `layouts/application` or `posts/index`;
* Currently layout inheritance isn't working correctly.

## About

Inspired by `view_component`, `cells` and others, currently this is a POC (proof of concept) to create a View layer
for Rails, it uses `ActionView` as the base for HTML views and it aims to work with the least amount of surprises on a
Rails application, but with a few boundaries, like a View won't be able to automatically access `@ivars` defined
in a controller, those have to explicitly be passed to them.

The project is already been tested on a small scale in our production environment.

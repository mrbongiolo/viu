# Viu

Currently this is a POC (proof of concept), on the usage of `ActionView` as a "real" view layer. Inspired on
`view_component`, `cells` and others, `viu` is just a small wrapper around `AV`. It aims to work with the least amount
of surprise with Rails, but with a few boundaries, like a View won't be able to automatically access `@ivars` defined
in the controller, those have to explicitly be passed to them.

The project is already been tested on a small scale in our production environment.

## Your first View

`app/views/my_view.rb`:
```ruby
class MyView < Viu::Html
  def initialize(name)
    @name = name
  end
end
```

`app/views/my_view.html.erb`:
```erb
<h1><%= @name %></h1>
```

Unless a template is given directly, a view will try to find a template with it's name.

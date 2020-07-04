# Viu

The objective of this project is provide a small encapsulation around views, so that they don't share state with controllers and such. Viu views should provide any kind of "response", doesn't really matter if it's HTML, JSON, YAML, smoke signal or whatever, just return something that the controller can send back to the response body.

That being said, the project should allow for easy of use when creating complex HTML forms and pages.

Given a blog with a CMS.

Basic structure:
```ruby
/views
  application_view.rb
  posts/
    index_view.rb
    index_view.html.erb
    show_view.rb
  users/
```

```ruby
class Posts::IndexView < ApplicationView
  # does the view decides about it's layout? Or should the caller do it? Maybe the caller can override if desired?
  
  def call(posts:, current_user:)
  end
end
```

```ruby
class PostsController < ApplicationController

  def index
    render html: Posts::IndexView.call(current_user: current_user)
    
    # or
    
    render html: Posts::IndexView.call(posts: Post.published_and_sorted, current_user: current_user)
  end
end
```

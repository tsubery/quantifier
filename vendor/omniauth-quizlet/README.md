OmniAuth Quizlet
================

This gem is an OmniAuth 1.0 Strategy for authenticating with the [Quizlet API](https://quizlet.com/api/2.0/docs)


Setup
-----

Register your application with [Quizlet](https://quizlet.com/api_dashboard/).

*Important*: your callback URL needs to be specified as `http://[hostname]/auth/quizlet/callback` or `http://[hostname]/users/auth/quizlet/callback`.

Usage
-----

Get started by adding the Quizlet strategy to your `Gemfile`:

```ruby
gem 'omniauth-quizlet'
```

In a Rails app, add the Quizlet provider to your Omniauth middleware, e.g.
in a file like @config/initializers/omniauth.rb@:

```ruby
Rails.application.config.middleware.use OmniAuth::Builder do
  provider :quizlet, ENV['QUIZLET_KEY'], ENV['QUIZLET_SECRET']
end
```

In any Rack app you can add the Quizlet strategy like so:

```ruby
use OmniAuth::Builder do
  provider :quizlet, ENV['QUIZLET_KEY'], ENV['QUIZLET_SECRET']
end
```

License
-------

Copyright (c) 2012 [kohactive](http://www.kohactive.com)

This source code released under an MIT license.

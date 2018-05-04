# Reck

An exception-based web framework for Ruby.

# Why another framework?

If you've ever programmed in Ruby on Rails, you know that it prefers convention
over configuration. We believe this approach works well as a design paradigm but
falls down over time (just ask anyone who has maintained a Rails application
since version 1). In order to remain competitive with newer high-level (and
often concurrent) programming languages like Node and Elixir, Ruby needs a
strong component-based framework which let's you use the *right* tool for the
job.

Reck is very light-weight compared to other web frameworks such as Rails
or even Sinatra. We handle the routing and controller layer using a very simple
exception-based DSL and then get out of the way so that any existing model or
view components may be used.

## Installation

```sh
$ gem install reck
```

## Usage

To respond to the defined route with rendered content, simply raise an
exception. The message of the exception will be evaluated as ERB before being
added to the response. If the exception is raised without a message, a
no-content response will be sent. This exception-based DSL is dead-simple and
great for controlling the flow of your application.

Routing code to a controller is as simple as:

```ruby
Reck.route '/' do |request|
  raise Reck::Ok, 'Hello World'
end
```

Want to add authentication? No problem. (Actually, with a single-page app, this *really is* all you need!)

```ruby
Reck.route '/admin' do |request|
  raise Reck::Forbidden unless request.params['username'] == 'admin'
  raise Reck::Forbidden unless request.params['password'] == 'secret'
  raise Reck::Ok, 'Super secret admin page'
end
```

Since the message of each exception is actually a template, use ERB tags to
interpolate Ruby values in your views:

```ruby
Reck.route '/version' do |request|
  raise Reck::Ok, 'Reck version: <%= Reck::VERSION %>'
end
```

Since Reck depends on Rack, you also have access to helper methods
derived from the keys in Rack's env hash:

```ruby
Reck.route '/method' do |request|
  raise Reck::Ok, 'Requested via: <%= request_method %>'
end
```

To run the application server:

```sh
$ ruby -r reck application.rb
```

## Supported Responses

Each response inherits from the exception `Reck::Response`.

| Exception Class       | Status code |
| --------------------- | ----------- |
| Reck::Ok              | 200         |
| Reck::Created         | 201         |
| Reck::Forbidden       | 403         |
| Reck::NotFound        | 404         |

## Handling exceptions

While responses should always be raised, you may wish to handle other types of
unexpected exceptions, or "exceptional exceptions", if you will. In these cases,
we recommend using Honeybadger. Honeybadger provides middleware (and a bunch of
other cool features) to catch exceptions in Ruby applications -- whether you're
using Reck, Rails, Sinatra, Rack, or rolling your own Ruby web-framework.

There are two ways you can get Honeybadger to monitor Reck:

1. Reporting errors inside a controller

  ```ruby
  require 'reck'
  require 'honeybadger'

  Honeybadger.configure do |config|
    config.api_key = 'your_api_key'
  end

  Reck.route '/oops' do |request|
    begin
      fail 'oops!'
    rescue Reck::Response
      raise # Raise the response to the router
    rescue => e
      # Exceptional Reck exception: report it with Honeybadger!
      Honeybadger.notify(e)
    end
  end
  ```

  ```sh
  ruby application.rb
  ```

2. Automatically catching all errors which aren't responses

  ```ruby
  require 'reck/application'
  require 'honeybadger'

  Honeybadger.configure do |config|
    config.api_key = 'your_api_key'
    config.exceptions.ignore << Reck::Response
  end

  Reck.route '/oops' do |request|
    fail 'oops!'
  end

  use Honeybadger::Rack::ErrorNotifier

  run Reck::Application
  ```

  ```sh
  rackup application.ru
  ```

Don't forget to replace `'your_api_key'` with the API key from your [project
settings page](https://www.honeybadger.io/) on Honeybadger.

## TODO

- [ ] Handle all HTTP 1.1 status codes
- [ ] Access to response headers
- [ ] Custom response formats

## Contributing

1. Fork it.
2. Create a topic branch `git checkout -b my_branch`
3. Commit your changes `git commit -am "Boom"`
3. Push to your branch `git push origin my_branch`
4. Send a [pull request](https://github.com/honeybadger-io/reck/pulls)

## License

Reck is Copyright 2015 © Honeybadger Industries LLC. It is free software, and
may be redistributed under the terms specified in the LICENSE file.

Brought to you by :zap: **Honeybadger.io**: our kick-ass exception tracking is no joke. :trollface:
[Start exterminating errors in your Ruby apps today](https://www.honeybadger.io/)!

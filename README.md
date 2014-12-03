# Honeybadger Framework

An exception-based web framework for Ruby.

# Why another framework?

If you've ever programmed in Ruby on Rails, you know that it prefers convention
over configuration. We believe this approach works well as a design paradigm but
falls down over time (just ask anyone who has maintained a Rails application
since version 1). In order to remain competitive against newer high-level (and
often concurrent) programming languages like Node and Elixir, Ruby needs a
strong component-based framework which let's you use the *right* tool for the
job.

Honeybadger is very light-weight compared to other web frameworks such as Rails
or even Sinatra. We handle the routing and controller layer using a very simple
exception-based DSL and then get out of the way so that any existing model or
view components may be used.

## Installation

```sh
gem install honeybadger-framework
```

## Usage

To respond to the defined route with rendered content, simply raise an
exception. The message of the exception will be evaluated as ERB before being
added to the response. If the exception is raised without a message, a
no-content response will be sent. This exception-based DSL is dead-simple and
great for controlling the flow of your application.

Routing code to a controller is as simple as:

```ruby
Honeybadger.route '/' do |request|
  raise Honeybadger::Ok, 'Hello World'
end
```

Want to add authentication? No problem. (Actually, with a single-page app, this *really is* all you need!)

```ruby
Honeybadger.route '/admin' do |request|
  raise Honeybadger::Forbidden unless request.params['username'] == 'admin'
  raise Honeybadger::Forbidden unless request.params['password'] == 'secret'
  raise Honeybadger::Ok, 'Super secret admin page'
end
```

Since the message of each exception is actually a template, use ERB tags to
interpolate Ruby values in your views:

```ruby
Honeybadger.route '/version' do |request|
  raise Honeybadger::Ok, 'Honeybadger version: <%= Honeybadger::VERSION %>'
end
```

Since Honeybadger depends on Rack, you also have access to helper methods
derived from the keys in Rack's env hash:

```ruby
Honeybadger.route '/method' do |request|
  raise Honeybadger::Ok, 'Requested via: <%= request_method %>'
end
```

## Supported Response Types

| Exception Class        | Status code |
| ---------------------- | ----------- |
| Honeybadger::Ok        | 200         |
| Honeybadger::Created   | 201         |
| Honeybadger::Forbidden | 403         |
| Honeybadger::NotFound  | 404         |

## TODO

- [ ] Handle all HTTP 1.1 status codes
- [ ] Access to response headers
- [ ] Custom response formats

## Contributing

1. Fork it.
2. Create a topic branch `git checkout -b my_branch`
3. Commit your changes `git commit -am "Boom"`
3. Push to your branch `git push origin my_branch`
4. Send a [pull request](https://github.com/honeybadger-io/honeybadger-framework/pulls)

## License

Honeybadger is Copyright 2015 © Honeybadger Industries LLC. It is free software, and
may be redistributed under the terms specified in the MIT-LICENSE file.

# Cobra

An exception-based web framework for Ruby.

# Why another framework?

If you've ever programmed in Ruby on Rails, you know that it prefers convention
over configuration. We believe this approach works well as a design paradigm but
falls down over time (just ask anyone who has maintained a Rails application
since version 1). In order to remain competitive against newer high-level (and
often concurrent) programming languages like Node and Elixir, Ruby needs a
strong component-based framework which let's you use the *right* tool for the
job.

Cobra is very light-weight compared to other web frameworks such as Rails
or even Sinatra. We handle the routing and controller layer using a very simple
exception-based DSL and then get out of the way so that any existing model or
view components may be used.

## Installation

```sh
$ gem install cobra-framework
```

## Usage

To respond to the defined route with rendered content, simply raise an
exception. The message of the exception will be evaluated as ERB before being
added to the response. If the exception is raised without a message, a
no-content response will be sent. This exception-based DSL is dead-simple and
great for controlling the flow of your application.

Routing code to a controller is as simple as:

```ruby
Cobra.route '/' do |request|
  raise Cobra::Ok, 'Hello World'
end
```

Want to add authentication? No problem. (Actually, with a single-page app, this *really is* all you need!)

```ruby
Cobra.route '/admin' do |request|
  raise Cobra::Forbidden unless request.params['username'] == 'admin'
  raise Cobra::Forbidden unless request.params['password'] == 'secret'
  raise Cobra::Ok, 'Super secret admin page'
end
```

Since the message of each exception is actually a template, use ERB tags to
interpolate Ruby values in your views:

```ruby
Cobra.route '/version' do |request|
  raise Cobra::Ok, 'Cobra version: <%= Cobra::VERSION %>'
end
```

Since Cobra depends on Rack, you also have access to helper methods
derived from the keys in Rack's env hash:

```ruby
Cobra.route '/method' do |request|
  raise Cobra::Ok, 'Requested via: <%= request_method %>'
end
```

To run the application server:

```sh
$ ruby -r cobra-framework application.rb
```

## Supported Response Types

| Exception Class        | Status code |
| ---------------------- | ----------- |
| Cobra::Ok              | 200         |
| Cobra::Created         | 201         |
| Cobra::Forbidden       | 403         |
| Cobra::NotFound        | 404         |

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

Cobra is Copyright 2015 © Honeybadger Industries LLC. It is free software, and
may be redistributed under the terms specified in the MIT-LICENSE file.

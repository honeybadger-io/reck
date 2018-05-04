# Reck

An exception-based web framework for Ruby.

---
Brought to you by :zap: **Honeybadger.io**: Zero-instrumentation, 360 degree coverage of errors, outages and service degradation. [Start exterminating errors in your Ruby apps today](https://www.honeybadger.io/)!

# Why another framework?

Reck is very light-weight compared to other web frameworks such as Rails
and Sinatra. We handle the routing layer using a very simple
exception-based DSL and then get out of the way so that you can use your preferred
model, view, and controller components.

## Installation

```sh
$ gem install reck
```

## Usage

To respond to the defined route with rendered content, simply raise an
exception. The message of the exception will be evaluated as ERB before being
added to the response. If the exception is raised without a message, a
no-content response will be sent. This exception-based DSL is great for controlling
the flow of your application.

Routing is as simple as:

```ruby
Reck.route '/' do |request|
  raise Reck::Ok, 'Hello World'
end
```

Want to add authentication? No problem.

```ruby
Reck.route '/admin' do |request|
  raise Reck::Forbidden unless request.params['username'] == 'admin'
  raise Reck::Forbidden unless request.params['password'] == 'secret'
  raise Reck::Ok, 'Super secret admin page'
end
```

The message of each exception is actually a template. Use ERB tags to
interpolate Ruby values in your views:

```ruby
Reck.route '/version' do |request|
  raise Reck::Ok, 'Reck version: <%= Reck::VERSION %>'
end
```

Reck depends on Rack. You also have access to helper methods
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
unexpected exceptions, or "exceptional exceptions". In these cases,
use [Honeybadger](https://www.honeybadger.io/). Honeybadger provides middleware (and a bunch of
other cool features) to monitor Ruby applications -- whether you're
using Reck, Rails, Sinatra, Rack, or rolling your own Ruby web-framework.

To monitor Reck for exceptions:

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

Reck is Copyright 2018 © Honeybadger Industries LLC. It is free software, and
may be redistributed under the terms specified in the LICENSE file.

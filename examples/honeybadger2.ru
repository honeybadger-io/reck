require 'reck/application'
require 'honeybadger'

Honeybadger.configure do |config|
  config.api_key = ENV['HONEYBADGER_API_KEY']
  config.exceptions.ignore = [Reck::Response]
  config.env = 'production'
end

Reck.route '/' do |request|
  raise Reck::Ok, 'Try /oops to simulate an error.'
end

Reck.route '/oops' do |request|
  fail 'oops!'
end

use Honeybadger::Rack::ErrorNotifier

run Reck::Application

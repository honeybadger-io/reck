require 'honeybadger'
require 'reck'

Honeybadger.configure do |config|
  config.exceptions.ignore = [Reck::Response]
  config.report_data = true
end

use Honeybadger::Rack::ErrorNotifier

Reck.route '/' do |request|
  raise Reck::Ok, 'Try /oops to simulate an error.'
end

Reck.route '/oops' do |request|
  fail 'oops!'
end

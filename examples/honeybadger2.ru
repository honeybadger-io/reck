require 'cobra/application'
require 'honeybadger'

Honeybadger.configure do |config|
  config.api_key = ENV['HONEYBADGER_API_KEY']
  config.ignore << Cobra::Response
end

Cobra.route '/' do |request|
  raise Cobra::Ok, 'Try /oops to simulate an error.'
end

Cobra.route '/oops' do |request|
  fail 'oops!'
end

use Honeybadger::Rack::ErrorNotifier

run Cobra::Application

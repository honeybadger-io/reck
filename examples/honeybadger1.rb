require 'reck'
require 'honeybadger'

Honeybadger.configure do |config|
  config.api_key = ENV['HONEYBADGER_API_KEY']
  config.env = 'production'
end

Reck.route '/' do |request|
  raise Reck::Ok, 'Try /oops to simulate an error.'
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

require 'cobra'
require 'honeybadger'

Honeybadger.configure do |config|
  config.api_key = ENV['HONEYBADGER_API_KEY']
end

Cobra.route '/' do |request|
  raise Cobra::Ok, 'Try /oops to simulate an error.'
end

Cobra.route '/oops' do |request|
  begin
    fail 'oops!'
  rescue Cobra::Response
    raise # Raise the response to the router
  rescue => e
    # Exceptional Cobra exception: report it with Honeybadger!
    Honeybadger.notify(e)
  end
end

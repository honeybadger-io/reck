require_relative 'cobra/application'

at_exit do
  Rack::Handler::WEBrick.run Cobra::Application
end

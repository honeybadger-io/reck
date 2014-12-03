require_relative 'cobra/application'

module Cobra
  at_exit do
    Rack::Handler::WEBrick.run Cobra::Application
  end
end

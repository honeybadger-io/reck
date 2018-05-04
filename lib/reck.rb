require 'reck/application'

module Reck
  at_exit do
    Rack::Handler::WEBrick.run Reck::Application
  end
end

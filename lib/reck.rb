require 'reck/application'

$middleware = []

def use(middleware, *args, &block)
  $middleware << [middleware, args, block]
end

module Reck
  at_exit do
    app = Rack::Builder.new

    $middleware.each { |c,a,b| app.use(c, *a, &b) }
    app.run(Reck::Application)

    begin
      Rack::Handler::WEBrick.run(app)
    rescue Interrupt
      # Clean exit
    end
  end
end

require 'reck'

Reck.route '/' do |request|
  raise Reck::Ok, 'Hello World'
end

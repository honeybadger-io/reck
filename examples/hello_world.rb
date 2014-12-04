require 'cobra'

Cobra.route '/' do |request|
  raise Cobra::Ok, 'Hello World'
end

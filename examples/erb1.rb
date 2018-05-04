require 'reck'

Reck.route '/version' do |request|
  raise Reck::Ok, 'Reck version: <%= Reck::VERSION %>'
end

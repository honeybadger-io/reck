require 'reck'

Reck.route '/admin' do |request|
  raise Reck::Forbidden unless request.params['username'] == 'admin'
  raise Reck::Forbidden unless request.params['password'] == 'secret'
  raise Reck::Ok, 'Super secret admin page'
end

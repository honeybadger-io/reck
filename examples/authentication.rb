require_relative '../lib/cobra'

Cobra.route '/admin' do |request|
  raise Cobra::Forbidden unless request.params['username'] == 'admin'
  raise Cobra::Forbidden unless request.params['password'] == 'secret'
  raise Cobra::Ok, 'Super secret admin page'
end

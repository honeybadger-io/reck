require_relative '../lib/cobra'

Cobra.route '/version' do |request|
  raise Cobra::Ok, 'Cobra version: <%= Cobra::VERSION %>'
end

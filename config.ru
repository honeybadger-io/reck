require 'rubygems'
require 'bundler/setup'

require 'rack'
require 'github/markup'

require_relative 'lib/cobra/application'

README = File.expand_path('../README.md', __FILE__)

Cobra.route '/version' do |request|
  raise Cobra::Ok, 'Cobra version: <%= Cobra::VERSION %>'
end

Cobra.route '/' do |request|
  raise Cobra::Ok, GitHub::Markup.render(README, File.read(README))
end

run Cobra::Application

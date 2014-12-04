require 'rubygems'
require 'bundler/setup'

require 'rack'
require 'erb'
require 'logger'
require 'github/markdown'
require 'linguist'
require 'html/pipeline'
require 'pygments'
require 'gemoji'
require 'tilt'
require 'honeybadger'

require 'cobra/application'

Honeybadger.configure do |config|
  config.api_key = ENV['HONEYBADGER_API_KEY']
  config.ignore << Cobra::Response
  config.logger = Logger.new(STDOUT)
  config.unwrap_exceptions = false
  config.project_root = Dir.pwd
end

layout = File.expand_path('../layout.erb', __FILE__)
readme = File.expand_path('../README.md', __FILE__)
pipeline = HTML::Pipeline.new [
  HTML::Pipeline::MarkdownFilter,
  HTML::Pipeline::SyntaxHighlightFilter,
  HTML::Pipeline::EmojiFilter
], {
  asset_root: 'https://assets-cdn.github.com/images/icons'
}
body = Tilt.new(layout).render { pipeline.call(File.read(readme))[:output].to_s }

Cobra.route '/version' do |request|
  raise Cobra::Ok, 'Cobra version: <%= Cobra::VERSION %>'
end

Cobra.route '/' do |request|
  raise Cobra::Ok, body
end

Cobra.route '/oops' do |request|
  fail 'oops'
end

use Honeybadger::Rack::ErrorNotifier

use Rack::Static, :urls => ['/stylesheets', '/javascripts', '/fonts', '/images'], :root => 'public'

run Cobra::Application

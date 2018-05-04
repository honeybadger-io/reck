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

require 'reck/application'

Honeybadger.configure do |config|
  config.api_key = ENV['HONEYBADGER_API_KEY']
  config.env = 'production'
  config.exceptions.ignore = [Reck::Response]
end

layout = File.expand_path('../layout.erb', __FILE__)
readme = File.expand_path('../README.md', __FILE__)
pipeline = HTML::Pipeline.new [
  HTML::Pipeline::MarkdownFilter,
  HTML::Pipeline::SyntaxHighlightFilter,
  HTML::Pipeline::EmojiFilter
], {
  asset_root: 'https://assets-cdn.github.com/images/icons',
  gfm: false
}

body = Tilt.new(layout).render { pipeline.call(File.read(readme))[:output].to_s }

Reck.route '/version' do |request|
  raise Reck::Ok, 'Reck version: <%= Reck::VERSION %>'
end

Reck.route '/' do |request|
  raise Reck::Ok, body
end

Reck.route '/oops' do |request|
  fail 'oops'
end

use Honeybadger::Rack::ErrorNotifier

use Rack::Static, :urls => ['/stylesheets', '/javascripts', '/fonts', '/images'], :root => 'public'

run Reck::Application

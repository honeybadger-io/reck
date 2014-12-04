require 'rubygems'
require 'bundler/setup'

require 'rack'
require 'erb'
require 'github/markdown'
require 'linguist'
require 'html/pipeline'
require 'pygments'
require 'gemoji'
require 'tilt'

require_relative 'lib/cobra/application'

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

run Cobra::Application

require File.expand_path('../lib/reck/version.rb', __FILE__)

Gem::Specification.new do |s|
  s.name        = 'reck'
  s.version     = Reck::VERSION
  s.platform    = Gem::Platform::RUBY
  s.summary     = 'An exception-based web framework for Ruby.'
  s.authors     = ['Honeybadger Industries LLC']
  s.email       = ['support@honeybadger.io']
  s.homepage    = 'https://github.com/honeybadger-io/reck'
  s.license     = 'MIT'

  s.required_ruby_version = '>= 2.1.0'

  s.files  = Dir['lib/**/*.rb']
  s.files += Dir['*.md']
  s.files += ['LICENSE']

  s.require_paths = ['lib']

  s.add_dependency 'rack'
end

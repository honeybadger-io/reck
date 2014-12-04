require 'rack'
require 'forwardable'

require_relative 'version'

module Cobra
  class Response < RuntimeError
    NOT_BLANK = Regexp.new('\S').freeze

    def head?
      message == self.class.name || message !~ NOT_BLANK
    end
  end

  class Ok < Response; end
  class Created < Response; end
  class Forbidden < Response; end
  class NotFound < Response; end

  STATUS = {
    Ok => 200,
    Created => 201,
    Forbidden => 403,
    NotFound => 404
  }.freeze

  class Application
    def self.call(env)
      req = Rack::Request.new(env)
      if route = routes.find {|r| r.path == req.path_info }
        route.call(req)
      else
        [404, {}, ['Not Found']]
      end
    rescue Cobra::Response => e
      [STATUS[e.class], {}, [e.head? ? nil : e.message].compact]
    rescue => e
      [500, {}, ['Internal Server Error']]
    end

    def self.routes
      @@routes ||= []
    end
  end

  class Route
    extend Forwardable
    attr_reader :path
    def_delegator :@block, :call

    def initialize(path, block)
      @path  = path
      @block = block
    end
  end

  def route(path, &block)
    Application.routes.unshift(Route.new(path, block))
  end

  extend self
end

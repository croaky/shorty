require File.join(File.dirname(__FILE__), '..', 'shorty')
require 'test/unit'
require 'rack/test'
require 'webrat'

Webrat.configure do |config|
  config.mode = :sinatra
end

set :environment, :test

class Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  class << self
    attr_accessor :name, :statements

    def Given(name, &block)
      @statements << [name, block]
    end
    %w(When Then Add).each { |name| alias_method name, :Given }

    def should(name, &block)
      test_name = "test_#{name.gsub(/\W+/, ' ').strip.gsub(/\s+/,'_')}".to_sym
      define_method(test_name, &block)
    end
  end
end

def Feature(name, &block)
  camelized = name.gsub(/\W+/, ' ').strip.gsub(/(^| )(\w)/) { $2.upcase }
  feature = Class.new(Test::Unit::TestCase)
  feature.name = name
  feature.statements = []
  Object.const_set(camelized, feature).class_eval(&block)
end

# research
#
# http://www.sinatrarb.com/testing.html
# http://gist.github.com/188594
# http://github.com/jferris/fontane/blob/master/features/support/env.rb


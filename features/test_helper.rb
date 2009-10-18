$LOAD_PATH << File.join(File.dirname(__FILE__, '..'))

require 'shorty'
require 'test/unit'
require 'rack/test'
require 'webrat'

Webrat.configure do |config|
  config.mode = :sinatra
end

set :environment, :test

class Test::Unit::TestCase
  include Rack::Test::Methods

  class << self
    attr_accessor :description, :statements
  end

  def app
    Sinatra::Application
  end

  def self.should(name, &block)
    test_name = "test_#{name.sub(/\s+/, "_").downcase}"
    define_method(test_name, &block)
  end

  def Given(name, &block)
    @statements << [name, block]
  end
  alias When Given
  alias Then Given
  alias And  Given
end

def Feature(name, &block)
  feature_class(name).class_eval(&block)
end

def feature_class(name)
  feature = Class.new(Test::Unit::TestCase)
  feature.description = name
  class_name = "Feature" + name.split(/\s|_/).map { |w| w.capitalize }.join
  Object.const_set(class_name, feature)
end

# research
#
# http://www.sinatrarb.com/testing.html
# http://gist.github.com/188594
# http://github.com/jferris/fontane/blob/master/features/support/env.rb


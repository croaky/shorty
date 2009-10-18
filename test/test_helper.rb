$LOAD_PATH << File.join(File.dirname(__FILE__, '..'))

require 'shorty'
require 'test/unit'
require 'rack/test'

set :environment, :test

class Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  def self.should(name, &block)
    test_name = "test_#{name.sub(/\s+/, "_").downcase}"
    define_method(test_name, &block)
  end
end

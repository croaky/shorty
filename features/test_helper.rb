require File.join(File.dirname(__FILE__), '..', 'shorty')
require 'test/unit'
require 'rubygems'
require "rack/test"
require 'webrat'

Webrat.configure do |config|
  config.mode = :rack
end

class Test::Unit::TestCase
  include Rack::Test::Methods
  include Webrat::Methods
  include Webrat::Matchers
  include Webrat::HaveTagMatcher

  def build_rack_mock_session
    Rack::MockSession.new(app, "www.example.com")
  end

  def app
    Rack::Builder.new {
      use Rack::Lint
      run RackApp.new
    }
  end
end

Statement = Struct.new(:type, :name, :block)

def Given(name, &block)
  Statement.new("Given", name, block)
end

def When(name, &block)
  Statement.new("When", name, block)
end

def Then(name, &block)
  Statement.new("Then", name, block)
end

def And(name, &block)
  Statement.new("And", name, block)
end

def Feature(name, &block)
  block.call
  statements = []
  ObjectSpace.each_object(Statement) { |statement| statements << statement }
  statements.reverse!
  eval(
    "class #{class_name(name)} < Test::Unit::TestCase
       def default_test
         instance_eval(#{ statements.each { |s| s.block.call } })
       end
     end")
end

def class_name(name)
  name.gsub(' ', '_').gsub(/(?:^|_)(.)/) { $1.upcase }
end

def test_name(name)
  "test_#{name.gsub(/\W+/,'_')}".to_sym
end

def concatenated_test_name(statements)
  test_name(statements.collect { |s| "#{s.type} #{s.name}" }.join(' '))
end


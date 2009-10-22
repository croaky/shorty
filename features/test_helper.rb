# research
#
# http://www.sinatrarb.com/testing.html
# http://gist.github.com/188594
# http://github.com/jferris/fontane/blob/master/features/support/env.rb

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
  @statements << Statement.new("Given", name, block)
end

def When(name, &block)
  @statements << Statement.new("When", name, block)
end

def Then(name, &block)
  @statements << Statement.new("Then", name, block)
end

def And(name, &block)
  @statements << Statement.new("And", name, block)
end

def Feature(name, &block)
  @statements = []
  block.call
  puts @statements.inspect
  eval(
    "class #{class_name(name)} < Test::Unit::TestCase
       def #{concatenated_test_name(@statements)}
         #{@statements.each { |statement| statement.block.call }}
       end
     end"
  )
end

def class_name(name)
  name.gsub(' ', '_').gsub(/(?:^|_)(.)/) { $1.upcase }
end

def test_name(name)
  "test_#{name.gsub(/\s+/,'_')}".to_sym
end

def concatenated_test_name(statements)
  test_name(
    statements.collect { |statement| "#{statement.type} #{statement.name}" }.
               join(' ')
  )
end


require File.join(File.dirname(__FILE__), '..', 'shorty')
require 'test/unit'
require 'rubygems'
require "rack/test"
require 'webrat'

Webrat.configure do |config|
  config.mode = :rack
end

module Teleplay
  include Rack::Test::Methods
  include Webrat::Methods
  include Webrat::Matchers
  include Webrat::HaveTagMatcher

  def app
    Sinatra::Application
  end

  Statement = Struct.new(:type, :name, :block)

  def Given(name, &block); Statement.new("Given", name, block); end
  def When(name, &block);  Statement.new("When",  name, block); end
  def Then(name, &block);  Statement.new("Then",  name, block); end
  def And(name, &block);   Statement.new("And",   name, block); end
end

class Test::Unit::TestCase
  include Teleplay
end

def Feature(name, &block)
  test_class = Module.const_set(class_name(name), Class.new(Test::Unit::TestCase))

  test_class.class_eval do
    def default_test
      statements = []
      ObjectSpace.each_object(Statement) { |s| statements << s }
      statements.reverse.each { |s| s.block.call }
    end
  end

  test_class.class_eval(&block)
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


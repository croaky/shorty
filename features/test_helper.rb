require File.join(File.dirname(__FILE__), '..', 'shorty')
require 'test/unit'
require 'rubygems'
require "rack/test"
require 'webrat'

Webrat.configure { |config| config.mode = :rack }

class Statement < Struct.new(:type, :name, :block); end

module CrazyHustlinRastaFrog
  def self.included(model)
    model.extend(ClassMethods)

    model.send(:include, Rack::Test::Methods)
    model.send(:include, Webrat::Methods)
    model.send(:include, Webrat::Matchers)
    model.send(:include, Webrat::HaveTagMatcher)
  end

  module ClassMethods
    def Given(name, &block); Statement.new("Given", name, block); end
    def When(name, &block);  Statement.new("When",  name, block); end
    def Then(name, &block);  Statement.new("Then",  name, block); end
    def And(name, &block);   Statement.new("And",   name, block); end
  end

  def app; Sinatra::Application; end
end

class Test::Unit::TestCase; include CrazyHustlinRastaFrog; end

def Feature(name, &block)
  test_class = Module.const_set class_name(name), Class.new(Test::Unit::TestCase)

  test_class.class_eval do
    def default_test
      statements = []
      ObjectSpace.each_object(Statement) { |s| statements << s }
      statements.reverse.each { |s| instance_eval(&s.block) }
    end
  end

  test_class.class_eval(&block)
end

def class_name(name)
  name.gsub(' ', '_').gsub(/(?:^|_)(.)/) { $1.upcase }
end

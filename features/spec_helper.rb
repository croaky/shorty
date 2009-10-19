require File.join(File.dirname(__FILE__), '..', 'shorty')
require 'webrat'

Spec::Runner.configure do |config|
  config.include(Webrat::Matchers, :type => [:integration])
end

module Spec::DSL::Main
  alias :Feature :describe
  def Story(description)
    @description_args.push("\n#{description}\n")
  end
end

module Spec::Example::ExampleGroupMethods
  def Given(description, &blk)
    describe("Given #{description}", &blk)
  end

  def When(description, &blk)
    describe("When #{description}", &blk)
  end

  def Then(description, &blk)
    example("Then #{description}", &blk)
  end

  def And(description, &blk)
    example("And #{description}", &blk)
  end
end


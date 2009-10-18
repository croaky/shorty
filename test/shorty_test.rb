require 'test_helper'

class ShortyTest < Test::Unit::TestCase
  should "display a URL shortener form" do
    get '/'

    assert last_response.ok?
    assert last_response.body.include?('form action="/shorten"')
  end
end


require File.join(File.dirname(__FILE__), 'test_helper')

Feature 'Shorten URL' do
  Given 'I am on the homepage' do
    visit '/'
  end

  When 'I submit http://dancroak.com' do
    fill_in      'url', :with => 'http://dancroak.com'
    click_button 'shorten'
  end

  Then 'I should see a short link' do
    assert_have_selector 'a#short'
  end

  When 'I follow the short link' do
    click_link 'short'
  end

  Then 'I should be on http://dancroak.com' do
    assert_equal 'http://dancroak.com', current_url
  end
end

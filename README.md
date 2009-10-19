Shorty
======

A URL shortener written in Sinatra and MongoDB.

Mongo
-----

Follow the [Ruby tutorial](http://www.mongodb.org/display/DOCS/Ruby+Tutorial) to learn how to interact with Mongo with Ruby.

Hosting
-------

I recommend using [Heroku](http://heroku.com) for the app and [MongoHQ](http://mongohq.com) for storage.

Features
--------

    Feature 'Shorten URL' do
      Given 'I am on the homepage' do
        visit '/'
      end

      When 'I submit http://dancroak.com' do
        fill_in      'url', :with => 'http://dancroak.com'
        click_button 'shorten'
      end

      Then 'I should see a short link' do
        response.should have_selector('a#short')
      end

      When 'I follow the short link' do
        click_link 'short'
      end

      Then 'I should be on http://dancroak.com' do
        current_url.should_be 'http://dancroak.com'
      end
    end


Shorty
======

A URL shortener written in Sinatra and MongoDB.

Mongo
-----

Follow the [Ruby tutorial](http://www.mongodb.org/display/DOCS/Ruby+Tutorial) to learn how to interact with Mongo with Ruby.

Hosting
-------

I recommend using [Heroku](http://heroku.com) for the app and [MongoHQ](http://mongohq.com) for storage.

Tests
-----

The app is tested in an acceptance style. It uses Rack::Test (which is built on top of Test::Unit), Webrat, and a custom Cucumber-ish DSL, using methods instead of pattern matching programming.


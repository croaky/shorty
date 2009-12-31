require 'groove'
Groove.config = { :db          => ENV['DATABASE']     || 'shorty',
                  :db_url      => ENV['DATABASE_URL'] || 'localhost',
                  :db_user     => ENV['DATABASE_USER'],
                  :db_password => ENV['DATABASE_PASSWORD'],
                  :hoptoad     => ENV['HOPTOAD'] }
require 'app'
run Sinatra::Application

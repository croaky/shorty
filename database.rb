require 'sinatra'
require 'sinatra/sequel'

set :database, (ENV['DATABASE_URL'] || 'sqlite://shorty.db')

migration "create urls" do
  database.create_table :urls do
    primary_key :id
    string      :url, :null => false, :length => 750

    index :url, :unique => true
  end
end

class Url < Sequel::Model
end


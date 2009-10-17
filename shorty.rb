require 'rubygems'
require 'sinatra'
require 'mongo'

include Mongo

DB = Connection.new(ENV['DATABASE_URL'] || 'localhost').db('shorty')
if ENV['DATABASE_USER'] && ENV['DATABASE_PASSWORD']
  auth = DB.authenticate(ENV['DATABASE_USER'], ENV['DATABASE_PASSWORD'])
end

get '/' do
  <<-HTML
    <title>URL shortener</title>
    <form action="/shorten" method="post">
      <input type="text" name="url" />
      <input type="submit" value="shorten" />
    </form>
    <p>Written in Sinatra and MongoDB.</p>
  HTML
end

post '/shorten' do
  reject_blank    params[:url]
  shorten         params[:url]
  slug = slug_for params[:url]
  "<a href='/#{slug}'>http://#{Sinatra::Application.host}/#{slug}</a>"
end

get '/:slug' do |slug|
  if url = url_for(slug)
    redirect(url)
  else
    halt(404)
  end
end

helpers do
  def reject_blank(url)
    redirect('/') unless url.size > 0
  end

  def shorten(url)
    puts DB.authenticate(ENV['DATABASE_USER'], ENV['DATABASE_PASSWORD'])
    DB['urls'].insert('url' => url, 'slug' => 'test')#DB['urls'].count.to_s(36))
  end

  def slug_for(url)
    DB['urls'].find('url' => url).collect {|row| row['slug'] }.flatten
  end

  def url_for(slug)
    DB['urls'].find('slug' => slug).collect {|row| row['url'] }.flatten
  end
end

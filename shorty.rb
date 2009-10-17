require 'rubygems'
require 'sinatra'
require 'database'

get '/' do
  <<-HTML
    <title>Shorty</title>
    <form action="/shorten" method="post">
      <input type="text" name="url" />
      <input type="submit" value="shorten" />
    </form>
  HTML
end

post '/shorten' do
  reject_blank params[:url]
  shorten      params[:url]
  id = id_for  params[:url]
  "<a href='/#{id}'>http://capeco.de/#{id}</a>"
end

get '/:id' do |id|
  if url = url_for(id)
    redirect(url)
  else
    "Not Found"
  end
end

helpers do
  def reject_blank(url)
    redirect('/') unless url.size > 0
  end

  def shorten(url)
    database[:urls].insert(:url => url) unless Url.find(:url => url)
  end

  def id_for(url)
    database["select id from urls where url = ?", url].to_s(36)
  end

  def url_for(id)
    database["select url from urls where id = ?", id.to_i(36)]
  end
end

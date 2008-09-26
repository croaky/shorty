# This came out of a Boston.rb hackfest
# I'm moving it to github
# I think someone challenged someone else
# to create a URL-shortening app
# in the fewest lines of Ruby possible

require 'rubygems'
require 'shorturl'
require 'camping'

Camping.goes :Short

module Short::Models
  class Url < Base
    before_save :shorten_url

    def shorten_url
      self.short_path = ShortURL.shorten self.long_path
    end
  end
end

module Short::Controllers
  class Show < R '/(\d+)'
    def get(short_path)
      @url = URL.find_by_short_path
      redirect @url.long_path
    end
  end
  
  class Create < R '/create'
    def get
      render :create
    end
    def post
      # consume form
    end
  end
end

module Short::Views
  def create
    form :action => handler, :method => 'post' do
      input :name => 'long_path', :id => 'long_path'
      input :type => 'submit', :value => 'Shorten'
    end
  end
end
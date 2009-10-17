require 'shorty'
require 'rack_hoptoad'

use Rack::HoptoadNotifier, ENV['HOPTOAD'] || "1234"

run Sinatra::Application

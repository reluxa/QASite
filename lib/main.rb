$: << File.join(File.dirname(__FILE__), "/../lib")

require 'bundler/setup'  
Bundler.require(:default)

use Rack::Session::Pool

require_relative 'helpers'
require_relative 'models/init'
require_relative 'routes/init'



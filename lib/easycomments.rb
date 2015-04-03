require "sinatra/base"
require "multi_json"
require "sequel"
require 'rack/cors'
require 'rack/utils'
require 'rack/protection'
require 'bcrypt'
require_relative "easycomments/ec_configuration.rb"
require_relative "easycomments/ec_pagination.rb"

VERSION = "1.0.4"

include Configuration

DB = Sequel.connect(CONNECTION)
DB.extension(:pagination)

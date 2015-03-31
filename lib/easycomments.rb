require "sinatra/base"
require "multi_json"
require "sequel"
require 'rack/cors'
require 'rack/utils'
require 'rack/protection'
require 'bcrypt'
require_relative "easycomments/ec_configuration.rb"

VERSION = "1.0.3"

include Configuration

DB = Sequel.connect(CONNECTION)

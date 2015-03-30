require 'yaml'

module Configuration
  
  extend self
  
  CONFIG = YAML.load_file('_config.yml')
  CONNECTION = CONFIG["connection"]
  APPROVE_BY_DEFAULT = CONFIG["approve_by_default"]
  ALLOW_ANONYMOUS_POST = CONFIG["allow_anonymous_post"]
  TIMESTAMP_FORMAT = CONFIG["timestamp_format"]
  USERNAME = CONFIG["username"]
  PASSWORD = CONFIG["password"]
  ALLOW_CORS = CONFIG["allow_cors"]
  CORS_ORIGIN = CONFIG["cors_origin"]

#wall of help text to be added in _config.yml
  def comment_wall
comments = <<COMMENTS
#
##connection : database connection url to be passed to sequel's connect method.
##check http://sequel.jeremyevans.net/rdoc/files/doc/opening_databases_rdoc.html
##all adapters supported by sequel can be used
#
##approve_by_default : set to true to allow all coments to be posted without moderation.
#
##allow_anonymous_post : set to true to allow comments without a name.
#
##timestamp_format : datetime format to be passed to strftime.
##see availabe options here http://ruby-doc.org/core-2.2.1/Time.html#method-i-strftime
#
##allow_cors : set to true to enable cross-origin resource sharing.
#
##cors_origin : see available formats here https://github.com/cyu/rack-cors
#
##users : do not edit this by hand use 'rake adduser' instead.
#
##if you edit this file after 'rake init' use 'rake update' for the changes to take effect.
#
COMMENTS
  end
end
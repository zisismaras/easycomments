require 'yaml'

module Configuration
  
  extend self
  
  #allows enviroment variables to be used as a connection option
  def check_env_var(var)
    if var =~ /ENV\[(.*)/ || var !~ /(:+)|(\/+)/
      env_var = var.sub("ENV[", "").sub("]","")
      var_seq = []
      env_var.split(//).each do |char|
        if char =~ /[0-9a-zA-Z]/
          var_seq.push(char)
        end
      end
      var = ENV[var_seq.join]
    end
    var
  end
  
  #configuration constants holding user options from _config.yml
  CONFIG = YAML.load_file('_config.yml')
  CONNECTION = check_env_var(CONFIG["connection"])
  APPROVE_BY_DEFAULT = CONFIG["approve_by_default"]
  ALLOW_ANONYMOUS_POST = CONFIG["allow_anonymous_post"]
  TIMESTAMP_FORMAT = CONFIG["timestamp_format"]
  USERNAME = CONFIG["username"]
  PASSWORD = CONFIG["password"]
  ALLOW_CORS = CONFIG["allow_cors"]
  CORS_ORIGIN = CONFIG["cors_origin"]
  AUTO_ESCAPE_HTML = CONFIG["auto_escape_html"]
  PAGINATE = CONFIG["paginate"]
  COMMENTS_PER_PAGE = CONFIG["comments_per_page"].to_i

  #wall of help text to be added in _config.yml
  def comment_wall
    comments = <<-COMMENTS
    #
    ##connection : database connection url to be passed to sequel's connect method.
    ##check http://sequel.jeremyevans.net/rdoc/files/doc/opening_databases_rdoc.html
    ##all adapters supported by sequel can be used
    ##you can also use an enviroment variable formatted as ENV["variable"] or just "variable" holding your db's url
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
    ##auto_escape_html : automatically escape html in comment bodies
    #
    ##paginate : set to true to have pagination support in comment retrieval
    #
    ##comments_per_page : how many comments to return per page if paginate is true
    #
    ##users : do not edit this by hand use 'rake adduser' instead.
    #
    ##if you edit this file after 'rake init' use 'rake update' for the changes to take effect.
    #
    COMMENTS
  end
end
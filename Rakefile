require "sequel"
require 'io/console'
require 'bcrypt'

require "bundler/gem_tasks"
require 'rspec/core/rake_task'

require_relative "lib/easycomments/ec_configuration.rb"

RSpec::Core::RakeTask.new
task :default => :spec

include Configuration

DB = Sequel.connect(CONNECTION) 

desc "Initializes EasyComments database"
task :init do
  DB.create_table :comments do
    primary_key :id
    String :name
    String :email
    String :post
    String :body
    TrueClass :approved, :default=>APPROVE_BY_DEFAULT
    TrueClass :action_taken, :default=>false
    DateTime :timestamp
  end
  puts "EasyComments database initialized."
end

desc "Updates EasyComments database."
task :update do
  DB.alter_table(:comments) do
    set_column_default :approved, APPROVE_BY_DEFAULT
  end
  puts "EasyComments database updated."
end

desc "Create a new user."
task :adduser do
  print "Username: "
  username = STDIN.gets.chomp
  print "Password for #{username}: "
  password = STDIN.noecho(&:gets).chomp
  bcrypt_password = BCrypt::Password.create(password)
  conf = CONFIG
  if conf[:users].nil?
    conf.merge!({:users => {username => bcrypt_password}})
  else
    conf[:users].merge!({username => bcrypt_password})
  end
  File.open("_config.yml", 'w') { |f| YAML.dump(conf, f) }
  File.open("_config.yml", 'a') { |f| f.write(comment_wall) }
  puts "\nNew user added."
end
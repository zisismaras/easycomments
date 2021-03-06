require "airborne"
require 'sqlite3'

require_relative "../ec.rb"
require_relative "../dashboard.rb"

def db_setup
  DB.create_table :comments do
    primary_key :id
    String :name
    String :email
    String :post
    String :body
    TrueClass :approved, :default => true
    TrueClass :action_taken, :default => false
    DateTime :timestamp
  end

  def add_new_comment
    DB[:comments].insert(:post => "one more post",
                    :name => "user",
                    :email => "user@user.com",
                    :body => "a body",
                    :timestamp => Time.now
                    ) 
   end

end

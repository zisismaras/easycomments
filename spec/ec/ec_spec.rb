require_relative '../spec_helper.rb'

Airborne.configure do |config|
  config.rack_app = EC
  config.before(:all) do
   #supress the warning for the already initialized constant
   #so we can change the configuration constants for testing
   #then restore it back
    original_verbosity = $VERBOSE
    $VERBOSE = nil
    DB = Sequel.sqlite
    $VERBOSE = original_verbosity
    db_setup
  end
  config.before(:each, :anonymous => true) do
    original_verbosity = $VERBOSE
    $VERBOSE = nil
    ALLOW_ANONYMOUS_POST = true
    $VERBOSE = original_verbosity
  end
  config.before(:each, :anonymous => false) do
    original_verbosity = $VERBOSE
    $VERBOSE = nil
    ALLOW_ANONYMOUS_POST = false
    $VERBOSE = original_verbosity
  end
  config.before(:each) do 
    add_new_comment
    config.rack_app = EC
  end
end

describe 'ec' do
  let(:example_post) {"one more post"}
  let(:example_comment) { 
    {:name => "user", :email => "user@user.com", :body => "a body", :post => "one more post"} 
  }
  let(:empty_comment) { 
    {:name => "user", :email => "user@user.com", :body => "", :post => "one more post"} 
  }
  let(:anonymous_comment) { 
    {:name => "", :email => "", :body => "a body", :post => "one more post"} 
  }

  describe "POST /comment" do
    context "allow anonymous comment" do
      it "posts successfully with name", :anonymous => true do
        post "/comment", example_comment
        expect_json({:status => "New comment posted."})
       end
      it "posts successfully without name", :anonymous => true do
        post "/comment", anonymous_comment
        expect_json({:status => "New comment posted."})
       end
      it "returns an error with emty comment", :anonymous => true do
        post "/comment", empty_comment
        expect_json({:status => "Error : no comment provided."})
       end
    end
    context "don't allow anonymous comment" do
      it "posts successfully with name", :anonymous => false do
        post "/comment", example_comment
        expect_json({:status => "New comment posted."})
       end
      it "posts returns an error without a name", :anonymous => false do
        post "/comment", anonymous_comment
        expect_json({:status => "Error : no name provided."})
       end
      it "returns an error with empty comment", :anonymous => false do
        post "/comment", empty_comment
        expect_json({:status => "Error : no comment provided."})
       end
    end
  end
  describe "GET /comments" do
    it "returns the comments successfully" do
      get "/comments?post=#{example_post}"
      expect_json_types({:comments => :array_of_objects})
    end
  end
end
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
    DB.extension(:pagination)
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
  config.before(:each, :paginate => false) do
    original_verbosity = $VERBOSE
    $VERBOSE = nil
    PAGINATE = false
    $VERBOSE = original_verbosity
  end
  config.before(:each, :paginate => true) do
    original_verbosity = $VERBOSE
    $VERBOSE = nil
    PAGINATE = true
    $VERBOSE = original_verbosity
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
    context "pagination is off" do
      it "returns the comments successfully", :paginate => false do
        get URI.encode("/comments?post=#{example_post}")
        expect_json_types({:comments => :array_of_objects})
      end
      it "it ignores page parameter", :paginate => false do
        get URI.encode("/comments?post=#{example_post}&page=1")
        expect_json_types({:comments => :array_of_objects})
      end
    end
    context "pagination is on" do
      it "returns the comments successfully", :paginate => true do
        get URI.encode("/comments?post=#{example_post}&page=1")
        expect_json_types({:comments => :array_of_objects, :page => :int, :total_pages => :int})
      end
      it "uses page 1 by default", :paginate => true do
        get URI.encode("/comments?post=#{example_post}")
        expect_json_types({:comments => :array_of_objects, :page => :int, :total_pages => :int})
        expect(json_body[:page]).to be == 1
      end
      it "fallbacks to page 1 with wrong page input", :paginate => true do
        get URI.encode("/comments?post=#{example_post}&page=-3")
        expect_json_types({:comments => :array_of_objects, :page => :int, :total_pages => :int})
        expect(json_body[:page]).to be == 1
      end
    end
  end
end
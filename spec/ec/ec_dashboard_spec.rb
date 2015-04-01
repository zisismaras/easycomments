require_relative '../spec_helper.rb'

Airborne.configure do |config|
  config.rack_app = ECDashboard
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
  config.before(:each) do 
    add_new_comment
    config.rack_app = ECDashboard
  end
end

describe 'ec_dasboard' do
  let(:example_post) {"one more post"}
  let(:example_comment) { 
    {:name => "user", :email => "user@user.com", :body => "a body", :post => "one more post"} 
  }

  describe "GET /comments" do
    it "returns the comments successfully" do
      get URI.encode("/comments?post=#{example_post}&page=1")
      expect_json_types({:comments => :array_of_objects, :page_count => :int})
    end
    it "uses page 1 by default" do
      get URI.encode("/comments?post=#{example_post}")
      expect_json_types({:comments => :array_of_objects, :page_count => :int})
    end
  end
  describe "GET /get_all_posts" do
    it "returns the post list successfully" do
      get "/get_all_posts"
      expect_json_types({:posts => :array_of_strings})
    end
  end
  describe "GET /get_total_pending" do
    it "returns the post list successfully" do
      get "/get_total_pending"
      expect_json_types({:pending => :int})
    end
  end
  describe "GET /get_posts_with_pending" do
    it "returns the post list with pending comments successfully" do
      get "/get_posts_with_pending"
      expect_json_types({:pending => :array_of_objects})
    end
  end
  describe "GET /get_pending_comments" do
    it "returns the comments successfully" do
      get URI.encode("/get_pending_comments?post=#{example_post}&page=1")
      expect_json_types({:comments => :array_of_objects, :page_count => :int})
    end
    it "uses page 1 by default" do
      get URI.encode("/get_pending_comments?post=#{example_post}")
      expect_json_types({:comments => :array_of_objects, :page_count => :int})
    end
  end
  describe "POST /edit_comment" do
    it "edits a comment successfully" do
      post "/edit_comment", {:id => 2, :new_body => "edited body"}
      expect_json({:status => "Comment successfully edited."})
    end
  end
  describe "POST /remove_comment" do
    it "removes a comment successfully" do
      post "/remove_comment", {:id => 2}
      expect_json({:status => "Comment successfully removed."})
    end
  end
  describe "POST /change_approval_status" do
    it "changes the approval status for a comment successfully" do
      post "/change_approval_status", {:id => 1}
      expect_json({:status => "Approval status successfully changed."})
    end
  end
  describe "POST /ignore_comment" do
    it "sets a comment as ignored successfully" do
      post "/ignore_comment", {:id => 4}
      expect_json({:status => "Comment successfully ignored."})
    end
  end
end
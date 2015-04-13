require_relative '../spec_helper.rb'

RSpec.configure do |config|
  config.before(:all){
    #set an example env variable
    ENV["MYDB"] = "sqlite://blog.db" 
  }
end

describe "allow enviroment variables as a connection option" do
  let(:conn_url) { "sqlite://blog.db" }
  context "with ENV[]" do
    context "with quotes" do
      it "returns the corrent connection url" do
        expect(Configuration::check_env_var("ENV[\"MYDB\"]")).to be == conn_url
      end
    end
    context "without quotes" do
      it "returns the corrent connection url" do
        expect(Configuration::check_env_var("ENV[MYDB]")).to be == conn_url
      end
    end
  end
  context "without ENV[]" do
    it "returns the corrent connection url" do
      expect(Configuration::check_env_var("MYDB")).to be == conn_url
    end
  end
  context "normal URL" do
    it "returns the corrent connection url" do
      expect(Configuration::check_env_var(conn_url)).to be == conn_url
    end
  end  
end
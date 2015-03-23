require File.dirname(__FILE__) + '/../app' 
require 'rspec'
require 'rack/test'

set :environment, :test
#Test::Unit::TestCase.send :include, Rack::Test::Methods

def app 
    Sinatra::Application
end

describe "app" do 
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end
  
  # before(:each) do
  #   User.delete_all
  # end

  describe "Creating a user and checking if it is created..." do 
    before(:each) do
      User.create(
        :username => "paul",
        :email => "paul@pauldix.net", 
        :password => "strongpass")
    end

    it "should return a user by name" do
      user = User.where(username: "paul") 
      user[0].username.should == "paul"
    end

    it "should return a user with an email" do
      user = User.where(username: "paul") 
      user[0].email.should == "paul@pauldix.net"
    end

    # it "should not return a user's password" do
    #   get '/api/v1/users/paul' 
    #   last_response.should be_ok
    #   attributes = JSON.parse(last_response.body) 
    #   attributes.should_not have_key("password")
    # end

    # it "should return a 404 for a user that doesn't exist" do 
    #   get "/profile/shouldnothavethis"
    #   last_response.status.should == 404
    # end
  end

  describe "Creating a tweet and checking if it is created..." do 
    before(:each) do
      Tweet.create(
        :text => "This is my tweet!",
        :user_id => 1)
    end

    it "should return a tweet by its text" do
      tweet = Tweet.where(text: "This is my tweet!") 
      tweet[0].text.should == "This is my tweet!"
    end

    it "should return a user with an email" do
      tweet = Tweet.where(user_id: 1) 
      tweet[0].user_id.should == 1
    end

    # it "should not return a user's password" do
    #   get '/api/v1/users/paul' 
    #   last_response.should be_ok
    #   attributes = JSON.parse(last_response.body) 
    #   attributes.should_not have_key("password")
    # end
  end

end
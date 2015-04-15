require File.dirname(__FILE__) + '/../app'
require 'rspec'
require 'rack/test'

#this isn't doing anything...
set :environment, 'test'

def app
    Sinatra::Application
end

describe "app" do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  before(:each) do
    User.delete_all
    Tweet.delete_all
  end

  describe "Creating a user and checking if it is created..." do
    before(:each) do
      User.create(
        :username => "paul",
        :email => "paul@pauldix.net",
        :password => "strongpass")
    end

    it "should return a user by name" do
      user = User.where(username: "paul")
      expect(user[0].username).to eq("paul")
    end

    it "should return a user with an email" do
      user = User.where(username: "paul")
      expect(user[0].email).to eq("paul@pauldix.net")
    end

    it "should return a 404 for a user that doesn't exist" do
      get "/profile/shouldnothavethis"
      expect(last_response.status).to eq(404)
    end
  end

  describe "Creating a tweet and checking if it is created..." do
    before(:each) do
      Tweet.create(
        :text => "This is my tweet!",
        :user_id => 1)
    end

    it "should return a tweet by its text" do
      tweet = Tweet.where(text: "This is my tweet!")
      expect(tweet[0].text).to eq("This is my tweet!")
    end

    it "should return a user with an email" do
      tweet = Tweet.where(user_id: 1)
      expect(tweet[0].user_id).to eq(1)
    end

    it "should not allow tweets to be longer than 140 characters" do
      tweet = Tweet.new(:text => "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaab",
        :user_id => 1)
      expect(tweet.save).to eq(false)
    end
  end

end

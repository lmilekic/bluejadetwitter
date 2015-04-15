require File.dirname(__FILE__) + '/../app'
require 'rspec'
require 'rack/test'

set :environment, :test

def app
    Sinatra::Application
end

describe "app" do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  describe "it should return JSON properly" do

    before(:each) do
      Tweet.destroy(002)

      Tweet.create(
        :id         => 0,
        :text       => "test suite spec test",
        :user_id    => 0,
        :created_at => "2015-04-15 05:05:05",
        :updated_at => "2015-04-15 05:05:10")
      end

      User.create(
        :id => 0,
        :username => "johndoe",
        :email => "jane@doe.com",
        :password => "apple",
        :logged_in => false,
        :created_at => "2015-04-15 05:05:05",
        :updated_at => "2015-04-15 05:05:10")

      User.create(
        :id => 1,
        :username => "fake",
        :email => "fake@email.com",
        :password => "fake",
        :logged_in => false,
        :created_at => "2015-04-15 05:05:05",
        :updated_at => "2015-04-15 05:05:10")

      # johndoe follows fake
      #UserFollowingUser.create(
        #:id => 0,
        #:user_id => 0,
        #:followed_user_id => 1)
    end

    after(:each) do 
      Tweet.destroy(0)
      User.destroy(0)
      User.destroy(1)
      UserFollowingUser.destroy(0)
    end

    describe "GET on /api/v1/tweets/:tid" do

      it "should return a Tweet" do
        get '/api/v1/tweets/0'
        expect(last_response).to be_ok
        json_response = JSON.parse(last_response)
        expect(json_response.class).to eq("Tweet")
      end

      it "should return a Tweet with text" do
        get '/api/v1/tweets/0'
        expect(last_response).to be_ok
        attributes = JSON.parse(last_response.body)
        expect(attributes["text"]).to eq("test suite spec test")
      end

      it "should return a Tweet with a user_id" do
        get '/api/v1/tweets/0'
        expect(last_response).to be_ok
        attributes = JSON.parse(last_response.body)
        expect(attributes["user_id"]).to eq(0)
      end

      it "should return a Tweet with dates" do
        get '/api/v1/tweets/0'
        expect(last_response).to be_ok
        attributes = JSON.parse(last_response.body)
        expect(attributes["created_at"]).to eq("2015-04-15 05:05:05")
        expect(attributes["updated_at"]).to eq("2015-04-15 05:05:10")
      end

      it "should return a 404 for a Tweet that doesn't exist" do
        get '/api/v1/tweets/002'
        expect(last_response.status).to eq(404)
      end
    end

    describe "GET on /api/v1/users/:uid" do

      it "should return a user" do
        get '/api/v1/users/0'
        expect(last_response).to be_ok
        json_response = JSON.parse(last_response)
        expect(json_response.class).to eq("User")
      end

      it "should return a user with a username" do
        get '/api/v1/users/0'
        expect(last_response).to be_ok
        attributes = JSON.parse(last_response.body)
        expect(attributes["username"]).to eq("johndoe")
      end

      it "should return a user with an email" do
        get '/api/v1/users/0'
        expect(last_response).to be_ok
        attributes = JSON.parse(last_response.body)
        expect(attributes["email"]).to eq("jane@doe.com")
      end

      it "should not return a user's password" do
        get '/api/v1/users/0'
        expect(last_response).to be_ok
        attributes = JSON.parse(last_response.body)
        expect(attributes).to_not have_key("password")
      end

      it "should return a user with a logged_in status" do
        get '/api/v1/users/0'
        expect(last_response).to be_ok
        attributes = JSON.parse(last_response.body)
        expect(attributes).to have_key("logged_in")
      end

      it "should return a user with dates" do
        get '/api/v1/tweets/0'
        expect(last_response).to be_ok
        attributes = JSON.parse(last_response.body)
        expect(attributes["created_at"]).to eq("2015-04-15 05:05:05")
        expect(attributes["updated_at"]).to eq("2015-04-15 05:05:10")
      end

      it "should return a 404 for a Tweet that doesn't exist" do
        get '/api/v1/users/020'
        expect(last_response.status).to eq(404)
      end
    end

    describe "GET on /api/v1/users/:uid/tweets" do

      it "should return an array of tweets"

      it "should return an empty array if user has made no tweets"

      it "should return a 404 for a user that doesn't exist" do
        get '/api/v1/users/020/tweets'
        expect(last_response.status).to eq(404)
      end
    end

    describe "GET on /api/v1/users/:uid/followers" do

      it "should return an array of users ids"

      it "should return an empty array if user does not follow anyone"

      it "should return a 404 for a user that doesn't exist" do
        get '/api/v1/users/020/followers'
        expect(last_response.status).to eq(404)
      end
    end
  end


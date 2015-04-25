require File.dirname(__FILE__) + '/../app'
require 'rspec'
require 'rack/test'

#this isn't doing anything...
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
      Tweet.delete_all
      User.delete_all
      FollowConnection.delete_all
    end

    describe "GET on /api/v1/tweets/:tid" do

      before(:each) do
        Tweet.create(
          :id         => 0,
          :text       => "test suite spec test",
          :user_id    => 0,
          :created_at => DateTime.now,
          :updated_at => DateTime.now)
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
        expect(attributes).to have_key("created_at")
        expect(attributes).to have_key("updated_at")
      end

      it "should return recent Tweets" do
        get '/api/v1/tweets/recent'
        expect(last_response).to be_ok
        expect(JSON.parse(last_response.body)).to be_a Array
      end

      it "should return a 404 for a Tweet that doesn't exist" do
        get '/api/v1/tweets/1'
        expect(last_response.status).to eq(404)
      end
    end

    describe "GET on /api/v1/users/:uid" do

      before(:each) do
        User.create(
          :id => 0,
          :username => "johndoe",
          :email => "jane@doe.com",
          :password => "apple",
          :logged_in => false,
          :created_at => DateTime.now,
          :updated_at => DateTime.now)
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
        get '/api/v1/users/0'
        expect(last_response).to be_ok
        attributes = JSON.parse(last_response.body)
        expect(attributes).to have_key("created_at")
        expect(attributes).to have_key("updated_at")
      end

      it "should return a 404 for a user that doesn't exist" do
        get '/api/v1/users/020'
        expect(last_response.status).to eq(404)
      end
    end

    describe "GET on /api/v1/users/:uid/tweets" do

      before(:each) do
        # don't need a real user
        User.create(:id => 0)
      end

      it "should return an array of tweets" do
        get '/api/v1/users/0/tweets'
        expect(last_response).to be_ok
        expect(JSON.parse(last_response.body)).to be_a Array
      end

      it "should return an empty array if user has made no tweets"

      it "should return a 404 for a user that doesn't exist" do
        get '/api/v1/users/1/tweets'
        expect(last_response.status).to eq(404)
      end
    end

    describe "GET on /api/v1/users/:uid/followers" do

      before(:each) do
        #FollowConnection.create(
        #  :id => 0,
        #  :user_id => 0,
        #  :followed_user_id => 1)
      end

      it "should return an array of users ids"

      it "should return an empty array if user does not follow anyone"

      it "should return a 404 for a user that doesn't exist" do
        get '/api/v1/users/9809897328463283/followers'
        expect(last_response.status).to eq(404)
      end
    end
  end
end
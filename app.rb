require 'sinatra'
require 'sinatra/activerecord'
require './config/environments'
require_relative 'models/user'
require_relative 'models/tweet'
require_relative 'models/user_following_user'
require './api_v1'

enable :sessions

get '/' do
  if(current_user)

      followers = current_user.followers.to_a
      followers_ids = followers.map{|x| x.id}

      # THIS NEEDS TO RETURN ALL OF THE PPL YOU ARE FOLLOWINGS'SS'S'S TWEETS
      @userTweets = Tweet.where("user_id = ?", followers_ids).to_a

      #this is a temporary fix:
      #@userTweets = []
      #@userTweets << Tweet.find(100176)
      #puts @userTweets

      erb :homepage
  else
    @publicFeed = Tweet.last(100).reverse.to_a
    erb :welcome
  end
end

get '/user' do
  if session[:username] != nil
    redirect '/user/' + session[:username]
  else
    redirect '/'
  end
end

get '/user/:user' do
  user = User.where(username: params[:user])
  if(user.first != nil)
    user_id = user.first.id
    @username = params[:user]
    @profileFeed = Tweet.where(user_id: user_id).to_a
    @self = false
    @current_user = current_user
    if @username == session[:username] then
      @self = true
    else
      @other_user = user.first
    end
    erb :profile
  else
    status 404
    "User's profile unable to be displayed. ｡゜(｀Д´)゜｡"
  end
end


get '/search' do
  query = params["q"]
  query_array = query.split
  results = Set.new
  #we're gonna do a full text search
  query_array.each do |q|
    t = Tweet.where('text LIKE ?', "%#{q}%")
    t.each do |tweet|
      results.add(tweet)
    end
  end
  @results = results
  erb :search
end


get '/logout' do
  session[:id] = nil
  redirect to('/')
end

private
def current_user
  if(session[:id].nil?)
    false
  else
    User.where(:id => session[:id]).first
  end
end

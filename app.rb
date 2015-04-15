require 'sinatra'
require 'sinatra/flash'
require 'sinatra/activerecord'
require './config/environments'
require_relative 'models/user'
require_relative 'models/tweet'
require_relative 'models/user_following_user'
require_relative 'api'
require_relative 'test_user'

configure :production do
  require 'newrelic_rpm'
  # use puma
  configure { set :server, :puma }
end



enable :sessions
before do
  cache_control :public
end

get '/loaderio-67d68465390333f8ce3945c9399a6717/' do
  "loaderio-67d68465390333f8ce3945c9399a6717"
end

get '/' do
  if(current_user)

      follows = current_user.followed_users.to_a
      follows_ids = follows.map{|x| x.id}
      puts "follows = :" + follows.to_s
      puts "follows_ids = " + follows_ids.to_s
      results = Set.new
      #we're gonna do a full text search
      follows_ids.each do |f|
        #This is a very hacky fix to allow following more than one person
        t = Tweet.where("user_id = ?", f).order('created_at').last(100/follows_ids.size).to_a
        t.each do |tweet|
          results.add(tweet)
        end
      end
      @userTweets = results.to_a.reverse

      erb :homepage
  else
    #this needs to be fixed:
    # doesnt' actually display latest 100 created tweets, but just the latest 100 IDs
    # not actually a problem irl but is problem with seed data
    @publicFeed = Tweet.last(100).to_a.reverse
    erb :welcome
  end
end

post '/user/register' do
  user = User.create(:username => params[:username],
  :email => params[:email],
  :password => params[:password] )
  if user.save
    session[:id] = user.id
    session[:username] = user.username
    UserFollowingUser.create(:user_id => current_user.id, :followed_user_id => current_user.id)
    redirect '/user/' + user.username
  else
    flash[:error] = "username or email is already taken"
    redirect '/'
  end
end

post '/login' do
  if params[:login].include? "@"
    user = User.where(:email => params[:login], :password => params[:password]).first
  else
    user = User.where(:username => params[:login], :password => params[:password]).first
  end

  if(user)
    session[:id] = user.id
    session[:username] = user.username
    redirect '/'
  else
    flash[:error] = "There was an error with login"
    redirect '/'
  end
end

post '/tweet' do
  tweet = Tweet.create(:text => params[:tweet_text],
  :user_id => session[:id],
  :created_at => Time.now) #I think created_at is auto_generated
  if tweet.save
    redirect back #refreshes
  else
    flash[:error] = "Tweet was unable to be saved or something!"
    redirect back
  end
end


post '/follow' do
  stalk = UserFollowingUser.create(:user_id => current_user.id, :followed_user_id => params["other_user_id"])
  if stalk.save
    status 200
    redirect back
  else
    status 400
    flash[:error] = "Following didn't work!"
    redirect back
  end
end

post '/unfollow' do
  current_user.user_following_users.where(:user_id => current_user.id, :followed_user_id => params["other_user_id"]).destroy_all
  redirect back
end

get '/user' do
  if session[:username] != nil
    redirect '/user/' + session[:username]
  else
    redirect '/'
  end
end

get '/user/:user' do
  #For listing followers/followees we should probably make it so it only calculates it once and changes when you unfollow someone
  user = User.where(username: params[:user])
  if(user.first != nil)
    user_id = user.first.id
    @username = params[:user]
    @profileFeed = Tweet.where(user_id: user_id).order('created_at').to_a.reverse!
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
    #"User's profile unable to be displayed. ｡゜(｀Д´)゜｡"
  end
end


get '/search' do
  query = params["q"]
  query_array = query.split
  @tweet_results = Set.new
  #we're gonna do a full text search
  query_array.each do |q|
    #This is a temporary fix for a large result set for searching
    t = Tweet.where('text LIKE ?', "%#{q}%").order('created_at').last(100/query_array.size)
    t.each do |tweet|
      @tweet_results.add(tweet)
    end
  end

  @user_results = Set.new
  u = User.where('username = ?', "#{query}")
  u.each do |user|
    @user_results.add(user)
  end

  erb :search
end

get '/logout' do
  session[:id] = nil
  redirect to('/')
  @user = nil
end

not_found do
  status 404
  erb :oops
end

private
#I think this is slowing us down
def current_user
  if(session[:id].nil?)
    false
  elsif @user.nil?
    puts "SHOULD DO THIS ONCE"
    @user = User.where(:id => session[:id]).first
  else
    @user
  end
  
end

require 'sinatra'
require 'sinatra/flash'
require 'sinatra/activerecord'
require './config/environments'
require 'json'
require_relative 'models/user'
require_relative 'models/tweet'
require_relative 'models/user_following_user'

enable :sessions

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
      @userTweets = results.to_a.reverse!

      # THIS NEEDS TO RETURN ALL OF THE PPL YOU ARE FOLLOWINGS'SS'S'S TWEETS
      #@userTweets = Tweet.where("user_id = ?", follows_ids).last(100).reverse.to_a
      #this is a temporary fix:
      #@userTweets = []
      #@userTweets << Tweet.find(100176)
      #puts @userTweets

      erb :homepage
  else
    @publicFeed = Tweet.last(100).order('created_at').to_a
    erb :welcome
  end
end

post '/api/v1/signup' do
  user = User.create(:username => params[:username],
  :email => params[:email],
  :password => params[:password] )
  if user.save
    session[:id] = user.id
    session[:username] = user.username
    redirect '/user/' + user.username
  else
    flash[:error] = "username or email is already taken"
    redirect '/'
  end
end

post '/api/v1/login' do
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

post '/api/v1/tweet' do
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


post '/api/v1/follow' do
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

post '/api/v1/unfollow' do
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
    @profileFeed = Tweet.where(user_id: user_id).order('created_at').to_a
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
  results = Set.new
  #we're gonna do a full text search
  query_array.each do |q|
    #This is a temporary fix for a large result set for searching
    t = Tweet.where('text LIKE ?', "%#{q}%").order('created_at').last(100/query_array.size)
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

not_found do
  status 404
  erb :oops
end

private
def current_user
  if(session[:id].nil?)
    false
  else
    User.where(:id => session[:id]).first
  end
end

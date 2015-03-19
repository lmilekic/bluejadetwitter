require 'sinatra'
require 'sinatra/activerecord'
require './config/environments'
require_relative 'models/user'
require_relative 'models/tweet'

enable :sessions

get '/' do
	session["user_id"] ||= nil
  # if user is signed in then erg :homepage else erb :welcome
  @publicFeed = Tweet.all.to_a
  erb :welcome
end

post '/api/v1/signup' do
	user = User.create(:username => params[:username],
						 #:email => params[:email],
						 :password => params[:password] )
	session["user_id"] = user.id
	session["username"] = user.username
	if user.save
		redirect "/profile/#{user.username}"
	else
		"Sorry, there was an error!"
	end
end

post '/api/v1/tweet' do
	tweet = Tweet.create(:text => params[:tweet_text],
							:user_id => session["user_id"], #temporarily for now, use userid 1
							# later on it shoudl be something like:
							# :reference => session[:userid]
							# or something
							:created_at => Time.now)
	if tweet.save
		redirect back #refreshes
	else
		"unable to tweet"
	end
end

get '/profile/:user' do
	user = User.where(username: params[:user])
	user_id = user[0].id
	@username = params[:user]
	@profileFeed = Tweet.where(user_id: user_id)

  erb :profile
end

get '/homepage' do

	@userTweets = Tweet.where(user_id: 1).to_a

	erb :homepage
end

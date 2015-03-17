require 'sinatra'
require 'sinatra/activerecord'
require './config/environments'
require_relative 'models/user'
require_relative 'models/tweet'

get '/' do
  # if user is signed in then erg :homepage else erb :welcome
  erb :welcome
end

post '/api/v1/signup' do
	user = User.create(:username => params[:username],
						 #:email => params[:email],
						 :password => params[:password] )
	if user.save
		redirect '/profile'
	else
		"Sorry, there was an error!"
	end
end

post '/api/v1/tweet' do
	tweet = Tweet.create(:text => params[:tweet_text],
							:reference => 1, #temporarily for now, use userid 1
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

get '/profile' do
  erb :profile
end

get '/homepage' do

	@userTweets = Tweet.where(reference: 1).to_a

	erb :homepage
end
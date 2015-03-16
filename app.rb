require 'sinatra'
require 'sinatra/activerecord'
require './config/environments'
require_relative 'models/user'
require_relative 'models/tweet'

get '/' do
  erb :welcome
  # if user is signed in redirect to /homepage?
end

post '/signup' do
	@user = User.create(:username => params[:username],
						 #:email => params[:email],
						 :password => params[:password] )
	if @user.save
		redirect '/profile'
	else
		"Sorry, there was an error!"
	end
end

get '/profile' do
  erb :profile
end

get '/homepage' do
	erb :homepage
	# tweet = tweet.create with params 'tweet' and get the current user, timestamp, etc.
	# and then tweet.save, redirect to refresh
	# else "sorry error" or whatevs
end
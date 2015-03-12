require 'sinatra'
require 'sinatra/activerecord'
require './config/environments'
require_relative 'models/user'

get '/' do
  erb :welcome
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
end
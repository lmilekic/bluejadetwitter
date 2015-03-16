require 'sinatra'
require 'sinatra/activerecord'
require './config/environments'
require_relative 'models/user'
require_relative 'models/tweet'

enable :sessions

get '/' do
	session["username"] ||= null
	session["password"] ||= null
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
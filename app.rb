require 'sinatra'
require 'sinatra/activerecord'
require './config/environments'

get '/' do
  erb :welcome
end

get '/profile' do
  erb :profile
end

get '/homepage' do
	erb :homepage
end
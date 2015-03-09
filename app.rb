require 'sinatra'
require 'sinatra/activerecord'
require './config/environments'

get '/' do
  erb :homepage
end

get '/profile' do
  erb :profile
end
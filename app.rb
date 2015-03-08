require 'sinatra'
require 'sinatra/activerecord'
require './config/environments'

get '/' do
  "hello world"
end

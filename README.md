# bluejade
This is our nanotwitter project! The creators of this project are Calvin Wang, Zach Hogan, Luka Milekic, and Clara Nice. Keeping to the requirements of the project we have done our best to  not only finish the bare minimum, but add some of our flare to the project.  As far as functionality, the basics are all available.  A user can tweet, follow other users, unfollow other users, see other users' profiles (and their own), and see their twitter feed.  In addition, whenn not logged in, there is a feed of the last 100 most recent tweets.  Using caching we have optimized this process and made it a much smoother process. Using active-record, our backend databases uses SQLite when run on a local machine and postgres when run on the production site. As far as our programming language and tool, we are using Ruby with Sinatra to build and run the server.
Sticking with RESTful design we are using HTTP requests to process messages whenever a user wants to do something. 

## Routes Explanation
require 'sinatra'
require 'sinatra/flash'
require 'sinatra/activerecord'
require './config/environments'
require 'hiredis'
require 'redis'
require_relative 'models/user'
require_relative 'models/tweet'
require_relative 'models/user_following_user'
require_relative 'api'
require_relative 'test_user'

configure :production do
  require 'newrelic_rpm'
  # use puma
  configure { set :server, :puma }
  uri = URI.parse(ENV["REDISTOGO_URL"])
  REDIS = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password, :driver => :hiredis)
end
configure :development do
  puts "development"
  REDIS = Redis.new(:driver => :hiredis)
end
enable :sessions
before do
  cache_control :public

  #redis?
end

get '/loaderio-67d68465390333f8ce3945c9399a6717/' do
  "loaderio-67d68465390333f8ce3945c9399a6717"
end

get '/' do

post '/user/register' do

post '/login' do

post '/tweet' do

post '/follow' do

post '/unfollow' do

get '/user' do

get '/user/:user' do


get '/search' do


get '/logout' do


## schemas

__users__
_has_many tweets_

field | data type
----- | -----
id | integer
name | text
email | text
username | text
password | text
logged_in | boolean
password | text
logged_in | boolean

__tweets__

field | data type
----- | -----
id | integer
user_id | integer
text | text

__user_following_users__
_many_to_many_

field | data type
----- | -----
id | integer
user_id | integer
followed_user_id | integer

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
require_relative 'user_actions'
require_relative 'routes'

configure :production do
  require 'newrelic_rpm'
  configure { set :server, :puma }
  uri = URI.parse(ENV["REDISTOGO_URL"])
  REDIS = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password, :driver => :hiredis)
end

configure :development do
  REDIS = Redis.new(:driver => :hiredis)
end

enable :sessions

before do
  cache_control :public
end

not_found do
  status 404
  erb :oops
end


def current_user
  if (session[:id].nil?)
    false
  elsif @user.nil?
    puts "SHOULD DO THIS ONCE"
    @user = User.where(:id => session[:id]).first
  else
    @user
  end
end

def addToQueue(tweet)
  tweet_hash = tweet.serializable_hash
  tweet_hash['owner'] = current_user.username
  REDIS.lpush("top100", tweet_hash.to_json)
end

#returns an array of hashes containing tweet data
def getRedisQueue
  # if redis top 100 has more than 100 tweets
  if (REDIS.lrange('top100', 0, -1).size > 100)
    while (REDIS.lrange('top100', 0, -1).size > 100)
      REDIS.rpop('top100')
    end
  end

  arr = REDIS.lrange('top100', 0, -1)
  arr.map!{ |el| JSON.parse(el) }

  arr
end
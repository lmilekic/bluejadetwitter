require 'sinatra'
require 'sinatra/activerecord'
require './config/environments'
require_relative 'models/user'
require_relative 'models/tweet'

enable :sessions

get '/' do
  # if user is signed in then erg :homepage else erb :welcome
  if(current_user)
    erb :homepage
  else
    erb :welcome
  end
end

post '/api/v1/signup' do
	user = User.create(:username => params[:username],
						 #:email => params[:email],
						 :password => params[:password] )
	if user.save
    session[:id] = user.id
		redirect '/profile'
	else
		"Sorry, there was an error!"
	end
end

post '/api/v1/login' do
  user = User.where(:username => params[:username], :password => params[:password])
  session[:id] = user.id
end

post '/api/v1/tweet' do
	tweet = Tweet.create(:text => params[:tweet_text],
							:user_id => session[:id], #temporarily for now, use userid 1
							# later on it shoudl be something like:
							# :reference => session[:userid]
							# or something
							:created_at => Time.now) #I think created_at is auto_generated
	if tweet.save
		redirect back #refreshes
	else
		"unable to tweet"
	end
end

get '/profile' do
  if(current_user)
    erb :profile
  else
    redirect to('/')
  end
end

get '/homepage' do

	@userTweets = Tweet.where(user_id: 1).to_a

	erb :homepage
end

private
def current_user
  if(session[:id].nil?)
    false
  else
    User.where(:id => session[:id])
  end
end

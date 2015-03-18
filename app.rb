require 'sinatra'
require 'sinatra/activerecord'
require './config/environments'
require_relative 'models/user'
require_relative 'models/tweet'
require_relative 'models/user_following_user'

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
							:user_id => 1, #temporarily for now, use userid 1
							# later on it should be something like:
							# :reference => session[:userid]
							# or something
							:created_at => Time.now)
	if tweet.save
		redirect back #refreshes
	else
		"unable to tweet"
	end
end


#BELOW is close to what we want to have this post request doing later, but it currently relies on too many other things

# post '/api/v1/follow/:id' do
# 	#TO FIX LATER -- THIS CURRENTLY RECREATES THIS SAME FOLLOWING CONNECTION OVER AND OVER
# 	#ALSO- need to add in reference to user id of the profile and user id of the person viewing the profile
#  	stalk = UserFollowingUser.create(:user_id => session[:id],
#  										:followed_user_id => params[:id])
#  	if stalk.save
#  		redirect back 
#  	else
#  		"IT DIDN'T WORK"
#  	end
# end

post '/api/v1/follow' do
	#TO FIX LATER -- THIS CURRENTLY RECREATES THIS SAME FOLLOWING CONNECTION OVER AND OVER
	#ALSO- need to add in reference to user id of the profile and user id of the person viewing the profile
 	stalk = UserFollowingUser.create(:user_id => 1,
 										:followed_user_id => 2)
 	if stalk.save
 		redirect back

 	else
 		"IT DIDN'T WORK"
 	end
end

post '/api/v1/unfollow' do
	#TO FIX LATER -- THIS CURRENTLY DELETES THIS SAME FOLLOWING CONNECTION OVER AND OVER
	#ALSO- need to add in reference to user id of the profile and user id of the person viewing the profile
 	
 	User.find(1).user_following_users.destroy_all

 	redirect back
end


get '/profile' do
  erb :profile
end

get '/homepage' do

	@userTweets = Tweet.where(user_id: 1).to_a

	erb :homepage
end
require 'sinatra'
require 'sinatra/activerecord'
require './config/environments'
require_relative 'models/user'
require_relative 'models/tweet'
require_relative 'models/user_following_user'

enable :sessions
before do
  puts "id is " + session[:id].to_s
end

get '/' do
  # if user is signed in then erg :homepage else erb :welcome
  if(current_user)
    redirect to('/homepage')
    #@userTweets = []
    #erb :homepage #This needs @userTweets to be defined
  else
  	@publicFeed = Tweet.all.to_a
    erb :welcome
  end
end

post '/api/v1/signup' do
	user = User.create(:username => params[:username],
						 :email => params[:email],
						 :password => params[:password] )
	if user.save
    	session[:id] = user.id
    	session[:username] = user.username
		redirect '/profile/' + user.username
	else
		"Sorry, there was an error!"
	end
end

post '/api/v1/login' do
  user = User.where(:email => params[:email], :password => params[:password]).first
  if(user)
    session[:id] = user.id
    session[:username] = user.username
    redirect '/homepage'
  else
    "there was an error"
  end
end

post '/api/v1/tweet' do
	tweet = Tweet.create(:text => params[:tweet_text],
							:user_id => session[:id], 
							:created_at => Time.now) #I think created_at is auto_generated
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
  if session[:username] != nil
    redirect '/profile/' + session[:username]
  else
    redirect '/'
  end
end

get '/profile/:user' do
  user = User.where(username: params[:user])
  user_id = user[0].id
  @username = params[:user]
  @profileFeed = Tweet.where(user_id: user_id).to_a
  @self = false
  if @username === session[:username] then @self = true end
  erb :profile
end

get '/homepage' do

	# THIS NEEDS TO RETURN ALL OF THE PPL YOU ARE FOLLOWINGS'SS'S'S TWEETS
	@userTweets = Tweet.where(user_id: session[:id]).to_a

	erb :homepage
end

get '/logout' do
  session[:id] = nil
  redirect to('/')
end
private
def current_user
  if(session[:id].nil?)
    false
  else
    User.where(:id => session[:id])
  end
end

post '/user/register' do
  user = User.create(
    :username => params[:username],
    :email => params[:email],
    :password => params[:password])
  if user.save
    session[:id] = user.id
    session[:username] = user.username
    UserFollowingUser.create(:user_id => current_user.id, :followed_user_id => current_user.id)
    redirect '/user/' + user.username
  else
    flash[:error] = "username or email is already taken"
    redirect '/'
  end
end

post '/login' do
  if params[:login].include? "@"
    user = User.where(:email => params[:login].downcase, :password => params[:password]).first
  else
    user = User.where(:username => params[:login].downcase, :password => params[:password]).first
  end

  if (user)
    session[:id] = user.id
    session[:username] = user.username
    redirect '/'
  else
    flash[:error] = "There was an error with login"
    redirect '/'
  end
end

post '/tweet' do
  tweet = Tweet.create(
    :text => params[:tweet_text],
    :user_id => session[:id],
    :created_at => Time.now)
  if tweet.save
    addToQueue(tweet)
    redirect back
  else
    flash[:error] = "Tweet was unable to be saved or something!"
    redirect back
  end
end

post '/follow' do
  stalk = UserFollowingUser.create(:user_id => current_user.id, :followed_user_id => params["other_user_id"])
  if stalk.save
    status 200
    redirect back
  else
    status 400
    flash[:error] = "Following didn't work!"
    redirect back
  end
end

post '/unfollow' do
  current_user.user_following_users.where(:user_id => current_user.id, :followed_user_id => params["other_user_id"]).destroy_all
  redirect back
end
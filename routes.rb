get '/' do
  if (current_user)
    follows = current_user.followed_users.to_a
    follows_ids = follows.map{ |x| x.id }
    follows_ids.push(session[:id])
    
    @userTweets = Tweet.where("user_id IN (?)", follows_ids).order('created_at').last(100).to_a
    erb :homepage
  else
    @publicFeed = getRedisQueue
    erb :welcome
  end
end

get '/user' do
  if session[:username] != nil
    redirect '/user/' + session[:username]
  else
    redirect '/'
  end
end

get '/user/:user' do
  # For listing followers/followees we should probably make it so it only calculates it once and changes when you unfollow someone
  user = User.where(username: params[:user])

  if (user.first != nil)
    user_id = user.first.id
    @username = params[:user]
    @profileFeed = Tweet.where(user_id: user_id).order('created_at').to_a.reverse!
    @self = false
    @current_user = current_user

    if @username == session[:username]
      @self = true
    else
      @other_user = user.first
    end

    erb :profile
  else
    status 404
    #"User's profile unable to be displayed. "
  end
end


get '/search' do
  query = params["q"]
  query_array = query.split
  @tweet_results = Set.new
  query_array.each do |q|
    #This is a temporary fix for a large result set for searching
    t = Tweet.where('text LIKE ?', "%#{q}%").order('created_at').last(100/query_array.size)
    t.each do |tweet|
      @tweet_results.add(tweet)
    end
  end

  @user_results = Set.new
  u = User.where('username = ?', "#{query}")
  u.each do |user|
    @user_results.add(user)
  end

  erb :search
end

get '/logout' do
  session[:id] = nil
  redirect to('/')
  @user = nil
end

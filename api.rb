require 'json'

get '/api/v1/tweets/:tid' do
	if (params[:tid] == "recent")
		tweets = Tweet.last(100).reverse
		
		if (tweets)
			recent = Array.new
			tweets.each do |tweet|
				recent << tweet
			end

			content_type :json
			recent.to_json
		else
			status 404
		end
	else
		tweet = Tweet.find(params[:tid])

		if (tweet) 
			content_type :json
			{	:id 		=> tweet.id,
				:text 		=> tweet.text,
				:user_id 	=> tweet.user_id,
				:created_at => tweet.created_at }.to_json
		else 
			status 404
		end
	end
end

get '/api/v1/users/:uid' do
	user = User.find(params[:uid])

	if (user) 
		content_type :json
		{	:id 		=> user.id,
			:username 	=> user.username,
			:email	 	=> user.email,
			:logged_in	=> user.logged_in,
			:created_at	=> user.created_at }.to_json
	else 
		status 404
		"user not found"
	end
end

get '/api/v1/users/:uid/tweets' do
	user = User.find(params[:uid])

	if (user)
		tweets = Tweet.where("user_id = ?", user.id)
		twt_list = Array.new

		tweets.each do |tweet|
			twt_list << tweet
		end

		content_type :json
		twt_list.to_json
	else
		status 404
		"user not found"
	end
end

get '/api/v1/users/:uid/followers' do
	user = User.find(params[:uid])

	if (user)
		followers = UserFollowingUser.where("followed_user_id = ?", user.id).to_a
		f_ids = Array.new

		followers.each do |user|
			f_ids << { "user_id" => user.user_id }
		end

		content_type :json
		f_ids.to_json
	else
		status 404
		"user not found"
	end
end
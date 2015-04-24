require 'json'

get '/api/v1/tweets/:tid' do
	if (params[:tid] == "recent")
		begin
			tweets = Tweet.last(100).reverse
		rescue
			error 404, {:error => "tweets not found"}.to_json
		else
			recent = Array.new
			tweets.each do |tweet|
				recent << tweet
			end

			content_type :json
			recent.to_json
		end
	else
		begin
			tweet = Tweet.find(params[:tid])
		rescue
			error 404, {:error => "tweet not found"}.to_json
		else
			content_type :json
			{	:id 		=> tweet.id,
				:text 		=> tweet.text,
				:user_id 	=> tweet.user_id,
				:created_at => tweet.created_at,
				:updated_at => tweet.updated_at }.to_json
		end
	end
end

get '/api/v1/users/:uid' do
	begin
		user = User.find(params[:uid])
	rescue
		error 404, {:error => "user not found"}.to_json
	else
		content_type :json
		{	:id 		=> user.id,
			:username 	=> user.username,
			:email	 	=> user.email,
			:logged_in	=> user.logged_in,
			:created_at => user.created_at,
			:updated_at => user.updated_at }.to_json
	end
end

get '/api/v1/users/:uid/tweets' do
	begin
		user = User.find(params[:uid])
	rescue
		error 404, {:error => "user not found"}.to_json
	else
		tweets = Tweet.where("user_id = ?", user.id)
		twt_list = Array.new

		tweets.each do |tweet|
			twt_list << tweet
		end

		content_type :json
		twt_list.to_json
	end
end

get '/api/v1/users/:uid/followers' do
	begin
		user = User.find(params[:uid])
	rescue
		error 404, {:error => "user not found"}.to_json
	else
		followers = FollowConnection.where("followed_user_id = ?", user.id).to_a
		f_ids = Array.new

		followers.each do |user|
			f_ids << { "user_id" => user.user_id }
		end

		content_type :json
		f_ids.to_json
	end
end

get '/api/v1/top100' do
	getRedisQueue.to_json
end

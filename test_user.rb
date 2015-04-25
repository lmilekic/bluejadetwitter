require 'faker'
get '/test_tweet' do
	tweet = (Tweet.create(
		  	:text => Faker::Hacker.say_something_smart,
		  	:user_id => 1002,
		  	:created_at => Time.now))
	if (tweet)
		tweet_hash = tweet.serializable_hash
		tweet_hash['owner'] = "test_user"
		REDIS.lpush("top100", tweet_hash.to_json)
		"created tweet"
	else
		"error creating tweet"
	end
end

get '/test_follow' do
	id = Random.rand(User.count)
	if (FollowConnection.exists?(user_id: 1002, followed_user_id: id))
		if (FollowConnection.where(:user_id => 1002, :followed_user_id => id).destroy_all)
			"unfollowed #{id}"
		else
			"unfollow error with #{id}"
		end
	else
		if (FollowConnection.create(:user_id => 1002, :followed_user_id => id))
			"follow relation created with #{id}"
		else
			"follow error with #{id}"
		end
	end
end

get '/test_user' do
	follows = User.find(1002).followed_users.to_a
    follows_ids = follows.map{ |x| x.id }
    results = Set.new

    follows_ids.each do |u_id|
      t = Tweet.where("user_id = ?", u_id).order('created_at').limit(100).to_a
      t.each do |tweet|
        results.add(tweet)
      end
    end
    @userTweets = results.to_a.reverse
    erb :homepage
end

get '/reset' do
	if (Tweet.where(user_id: 1002).destroy_all) && (FollowConnection.where(user_id: 1002).destroy_all)
		"reset test user's stuff"
	else
		"error resetting"
	end
end

get '/refresh' do
	tweets = Tweet.order('created_at').limit(100).to_a
	tweets.each do |twt|
		tmp = Tweet.create(:text => twt.text, :user_id => twt.user_id, :created_at => twt.created_at)
		tweet_hash = tmp.serializable_hash
		tweet_hash['owner'] = User.where('id = ?', tmp.user_id)[0].username
		puts 'HASH IS ' + tweet_hash.to_s
  		tweet_hash['display_date'] = DateTime.parse(tweet_hash['created_at'].to_s).strftime("%b %e, %l:%M%P")
  		REDIS.lpush("top100", tweet_hash.to_json)
  	end
	"refreshed queue"
end

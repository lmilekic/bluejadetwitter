require 'faker'
get '/test_tweet' do
	tweet = (Tweet.create(
		  	:text => Faker::Hacker.say_something_smart,
		  	:user_id => 1011,
		  	:created_at => Time.now))
	if (tweet)
		"created tweet"
	    addToQueue(tweet)
	else
		"error creating tweet"
	end
end

get '/test_follow' do
	id = Random.rand(User.count)
	if (UserFollowingUser.exists?(user_id: 1011, followed_user_id: id))
		if (UserFollowingUser.where(:user_id => 1011, :followed_user_id => id).destroy_all)
			"unfollowed #{id}"
		else
			"unfollow error with #{id}"
		end
	else
		if (UserFollowingUser.create(:user_id => 1011, :followed_user_id => id))
			"follow relation created with #{id}"
		else
			"follow error with #{id}"
		end
	end
end

get '/reset' do
	if (Tweet.where(user_id: 1011).destroy_all) && (UserFollowingUser.where(user_id: 1011).destroy_all)
		"reset test user's stuff"
	else
		"error resetting"
	end
end
require 'sinatra'
require 'sinatra/activerecord'
require './config/environments'
require 'faker'


#100 users
# 10 tweets each
# each follows 10 people

puts "This is the seed file!!!"

test_users = Array.new

(0..99).each do
	#create user
	user = User.create(:username => Faker::Internet.user_name,
						 :password => Faker::Internet.password)

	if user.save
		"#{user.username} is now a test user!"
	else
		"unable to save user"
	end

	test_users << user

	#make each test user tweet 10 times
	(0..9).each do |i|
		tweet = Tweet.create(:text => Faker::Hacker.say_something_smart,
							:user_id => user.id,
							:created_at => Time.now)
		if tweet.save
			"tweet attempt: #{i} for #{user.username} is a success!!!"
		else
			"unable to make #{user.username} tweet on attempt: #{i}"
		end
	end
end

# Make each user follow 10 other random users
test_users.each do |user|
	to_follow = test_users.sample.id

	stalk = UserFollowingUser.create(:user_id => user.id,
 										:followed_user_id => to_follow)
	if stalk.save
		"user #{user.id} is now following #{to_follow}"
	else
		"user #{user.id}unable to follow #{to_follow}"
	end
end
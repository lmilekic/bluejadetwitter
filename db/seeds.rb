require 'sinatra'
require 'sinatra/activerecord'
require './config/environments'
require 'faker'
require './app'

#100 users
# 10 tweets each
# each follows 10 people

puts "Inserting Nick's data into db."

File.foreach( 'seeds/users.csv' ) do |user|

		user = User.create(:username => user.split(',')[1].tr("\r\n",""),
							:email => Faker::Internet.email,
							:password => Faker::Internet.password)
		if user.save

		else
			puts "*** UNABLE TO SAVE USER #{user.split(',')[1]}"
		end

end

count = 0
File.foreach( 'seeds/tweets_tabs.csv' ) do |tweet|
	twt = tweet.split('	')


		tweet = Tweet.create(:user_id => twt[0],
							:text => twt[1],
							:created_at => twt[2])
		count = count+1
		if tweet.save
			if (count%1000 == 0) then puts count end
		else
			puts "*** UNABLE TO SAVE TWEET"
		end

end

File.foreach( 'seeds/follows.csv' ) do |follow|
	flw = follow.split(',')

		stalk = UserFollowingUser.create(:user_id => flw[0],
							:followed_user_id => flw[1])
		if stalk.save

		else
			puts "*** user #{flw[0]} UNABLE TO FOLLOW #{flw[1]}"
		end

end

require 'json'

get '/api/v1/tweets/:tid' do
  #- return tweet with id
  content type :json
  tweet = Tweet.find(params[:tid])
  if (tweet)
    {"id" => tweet.id, "text" => "#{tweet.text}", "created" => tweet.created_at}.to_json
  else
    status 404
    "Tweet not found"
  end
end

get '/api/v1/users/:id' do
# - return user information for user 23
end

get '/api/v1/tweets/recent' do
# return the recent n tweets
end

get '/api/v1/users/23/tweets' do
# - return the users recent tweets
end
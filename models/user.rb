class User < ActiveRecord::Base
  has_many :tweets
  has_many :user_following_users, :foreign_key => :user_id
  has_many :followed_users, :class_name => :User, :through => :user_following_users, :source => :followed_user
  has_many :reverse_followings, :class_name => :UserFollowingUser, :foreign_key => :followed_user_id
  has_many :followers, :class_name => :User, :through => :reverse_followings, :source => :user

  def to_json
  	super(:except => :password)
  end
end

class User < ActiveRecord::Base
  validates_uniqueness_of :username, :email

  has_many :tweets
  has_many :follow_connections, :foreign_key => :user_id
  has_many :followed_users, :class_name => :User, :through => :follow_connections, :source => :followed_user
  has_many :reverse_followings, :class_name => :FollowerConnection, :foreign_key => :followed_user_id
  has_many :followers, :class_name => :User, :through => :reverse_followings, :source => :user

  def to_json
  	super(:except => :password)
  end
end

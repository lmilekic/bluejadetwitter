class User < ActiveRecord::Base
  has_many :tweets

  def to_json
  	super(:except => :password)
  end
end

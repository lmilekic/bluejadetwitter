class CreateFollowTable < ActiveRecord::Migration
  def up
  	create_table :user_following_users do |t|
  		t.integer :user_id
  		t.integer :followed_user_id
  	end
  end
end

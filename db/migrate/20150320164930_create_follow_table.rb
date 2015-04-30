class CreateFollowTable < ActiveRecord::Migration
  def up
  	create_table :follow_connections do |t|
  		t.integer :user_id
  		t.integer :followed_user_id
  	end
  end
end

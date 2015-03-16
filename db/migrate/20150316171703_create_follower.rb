class CreateFollower < ActiveRecord::Migration
  def change
  	create_table :followers do |t|
  		t.integer :follower_id
  		t.integer :followee_id
  	end
  end
end

class CreateTweets < ActiveRecord::Migration
  def up
  	create_table :tweets do |t|
  		t.string :text
  		t.integer :reference
  		t.datetime :created_at

  		t.timestamps null: false
  	end
  end
end

class CreateTweets < ActiveRecord::Migration
  def up
  	create_table :tweets do |t|
  		t.string :text
  		t.integer :reference
  		t.datetime :date

  		t.timestamps null: false
  	end
  end
end

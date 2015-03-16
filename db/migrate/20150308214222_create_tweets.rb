class CreateTweets < ActiveRecord::Migration
  def change
    create_table :tweets do |t|
      t.text :text
      t.integer :reference
      t.datetime :date
      t.timestamps null: false
    end
  end
end

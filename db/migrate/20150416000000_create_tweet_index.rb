class CreateTweetIndex < ActiveRecord::Migration
  def up
  	add_index(:tweets, :created_at)
  end
end

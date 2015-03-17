class CreateUsers < ActiveRecord::Migration
  def up
  	create_table :users do |t|
  		t.string :username
  		t.string :email
  		t.string :password
  		t.boolean :logged_in, default: false
  		t.timestamps null: false
  	end
  end
end

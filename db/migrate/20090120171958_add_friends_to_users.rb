class AddFriendsToUsers < ActiveRecord::Migration
  def self.up
    create_table :friendships, :id => false do |t|
      t.integer :user_id
      t.integer :friend_id
    end
  end

  def self.down
    drop_table :friendships
  end
end

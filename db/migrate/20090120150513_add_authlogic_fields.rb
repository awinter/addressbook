class AddAuthlogicFields < ActiveRecord::Migration
  def self.up
    change_table :users do |t|
       t.string    :crypted_password
       t.string    :password_salt  
       t.string    :persistence_token
    end
  end

  def self.down
    remove_column :users, :crypted_password
    remove_column :users, :password_salt
    remove_column :users, :persistence_token
  end
end

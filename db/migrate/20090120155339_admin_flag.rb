class AdminFlag < ActiveRecord::Migration
  def self.up
    change_table :users do |t|
       t.boolean   :admin
    end
  end

  def self.down
    remove_column :users, :admin
  end
end

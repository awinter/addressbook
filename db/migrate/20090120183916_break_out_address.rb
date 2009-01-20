class BreakOutAddress < ActiveRecord::Migration
  def self.up
    create_table :addresses do |t|
      t.integer :user_id
      t.string :street1
      t.string :street2
      t.string :city
      t.string :state
      t.string :zip
      t.float :longitude
      t.float :latitude
      t.timestamps
    end
    
    change_table :users do |t|
      t.remove :street1
      t.remove :street2
      t.remove :city
      t.remove :state
      t.remove :zip
    end
    
  end

  def self.down
    create_table :users do |t|
      t.string :street1
      t.string :street2
      t.string :city
      t.string :state
      t.string :zip
    end
    
    drop_table :addresses
    
  end
end

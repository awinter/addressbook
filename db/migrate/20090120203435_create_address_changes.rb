class CreateAddressChanges < ActiveRecord::Migration
  def self.up
    create_table :address_changes do |t|
      t.integer :address_id
      t.timestamps
    end
  end

  def self.down
    drop_table :address_changes
  end
end

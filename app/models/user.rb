class User < ActiveRecord::Base
  # Using Authlogic. See write-up for why chosen of Restful Authentication
  acts_as_authentic # for options see documentation: Authlogic::ORMAdapters::ActiveRecordAdapter::ActsAsAuthentic::Config
  
  # Using Paperclip to aid in file storage
  has_attached_file :photo
  
  # Need to overide the defaults of has_and_belongs_to_many so that I can specify a many to many relationship using
  # the same table on both sides of the relationship.
  has_and_belongs_to_many :friends, :join_table => "friendships", :association_foreign_key => "friend_id", :class_name => "User"
  
  # For now, users have just one address. This may change in the future.
  has_one :address
  
  # Helper function to return the cached geo-coordinates in an array
  def geo_coords
    if address && address.longitude && address.latitude
      [address.latitude, address.longitude]
    end
  end
  
  # Helper function to constuct a user's full name
  def full_name
    "#{first_name} #{last_name}"
  end
  
end

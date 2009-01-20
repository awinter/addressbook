class User < ActiveRecord::Base
  acts_as_authentic # for options see documentation: Authlogic::ORMAdapters::ActiveRecordAdapter::ActsAsAuthentic::Config
  has_attached_file :photo
  
  has_and_belongs_to_many :friends, :join_table => "friendships", :association_foreign_key => "friend_id", :class_name => "User"
  
  has_one :address
  
  def geo_coords
    if address && address.longitude && address.latitude
      [address.latitude, address.longitude]
    end
  end
  
  def full_name
    "#{first_name} #{last_name}"
  end
  
end

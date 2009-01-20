class User < ActiveRecord::Base
  acts_as_authentic # for options see documentation: Authlogic::ORMAdapters::ActiveRecordAdapter::ActsAsAuthentic::Config
  
  has_and_belongs_to_many :friends, :join_table => "friendships", :association_foreign_key => "friend_id", :class_name => "User"
end

# This coordinates the ability for user to designate which other users are his "friends"
class FriendshipsController < ApplicationController

  # GET /users/1/friendships
  def index
    # Find the selected (often current, unless being done by an admin) user
    @user = User.find(params[:user_id])
    
    # Find all users, but removing the selected user (can't be a friend of yourself - wouldn't make sense)
    @users = User.find(:all) - [@user]
    
    # A list of your friends for the view to render
    @friends = @user.friends

    respond_to do |format|
      format.html # index.html.erb
    end
  end
end

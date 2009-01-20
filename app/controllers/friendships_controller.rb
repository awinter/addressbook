class FriendshipsController < ApplicationController

  # GET /users/1/friendships
  def index
    @user = User.find(params[:user_id])
    @users = User.find(:all) - [@user]
    @friends = @user.friends

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @users }
    end
  end
end

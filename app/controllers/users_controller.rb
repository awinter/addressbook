# Controls the main screen of the app. Coordinates map display, as well as addessbook listing.
class UsersController < ApplicationController
  # Can't require a user to log in to create a new user, so adding skip_before_filter
  skip_before_filter :require_user, :only => [:new, :create]
  
  # Adding security to the edit, update and destroy functions - can only be done by user to oneself or by an admin
  before_filter :require_admin_or_self, :only => [:edit, :update, :destroy]
  
  # GET /users
  def index
    
    # Do we just want to display our close friends, or all users?
    if params[:friends_only] 
      @users = current_user.friends
    else
      @users = User.find(:all)
    end
    
    # Set up the Google Map integration
    @map = GMap.new("map_div")
    @map.control_init(:large_map => true,:map_type => true)
    # By default, zoom in on the current user, so they can see where their friends are relative to themselves
    if current_user.geo_coords
      @map.center_zoom_init(current_user.geo_coords,3)
    else
      # If the current user hasn't set a location, then let's focus on Columbus, OH
      @map.center_zoom_init([40.034874,-83.04701],3)
    end
    
    # Overlay user/friend information on top of the Google Map
    # Note the use of a partial to construct the html in the info window
    for user in @users
      @map.overlay_init(GMarker.new(user.geo_coords, :title => "#{user.full_name}", :info_window => render_to_string(:partial => 'info_window', :locals => {:user => user}))) if user.geo_coords
    end
    
    respond_to do |format|
      format.html # index.html.erb
    end
  end

  # View a user's complete address information
  # GET /users/1
  def show
    @user = User.find(params[:id])
    @address = @user.address || Address.new
    
    respond_to do |format|
      format.html # show.html.erb
    end
  end

  # Prepare to create a new user
  # GET /users/new
  def new
    @user = User.new
    @address = @user.build_address

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  # Edit an existing user
  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
    @address = @user.address || @user.build_address
  end

  # Handle the submission of a request to create a new user
  # POST /users
  def create
    @user = User.new(params[:user])
    @user.build_address(params[:address])

    respond_to do |format|
      if @user.save
        flash[:notice] = 'User was successfully created.'
        format.html { redirect_to(@user) }
      else
        format.html { render :action => "new" }
      end
    end
  end

  # Handle the submission of a request to update a user
  # PUT /users/1
  def update
    @user = User.find(params[:id])
    @address = @user.address || @user.build_address

    respond_to do |format|
      if @user.update_attributes(params[:user]) && @address.update_attributes(params[:address])
        flash[:notice] = 'User was successfully updated.'
        format.html { redirect_to(@user) }
      else
        format.html { render :action => "edit" }
      end
    end
  end
  
  # Handle a request to update a user's list of friends
  def update_friends
    @user = User.find(params[:id])

    respond_to do |format|
      if @user.update_attributes(params[:user])
        flash[:notice] = 'Your friends were updated successfully.'
        format.html { redirect_to(user_friendships_path(@user)) }
      else
        format.html { render :action => "edit" }
      end
    end
  
  end

  # Users may delete their own accounts, if they wish
  # DELETE /users/1
  def destroy
    @user = User.find(params[:id])
    @user.destroy

    respond_to do |format|
      format.html { redirect_to(users_url) }
    end
  end

  private
  # Handle security for protected functions
  def require_admin_or_self
    unless current_user.admin? || current_user == User.find(params[:id])
      flash[:notice] = "You must be an admin to access this page"
      redirect_to users_path
      return false
    end
  end
end

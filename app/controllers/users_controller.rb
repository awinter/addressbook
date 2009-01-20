class UsersController < ApplicationController
  skip_before_filter :require_user, :only => [:new, :create]
  before_filter :require_admin_or_self, :only => [:edit, :update, :destroy]
  
  # GET /users
  # GET /users.xml
  def index
    if params[:friends_only] 
      @users = current_user.friends
    else
      @users = User.find(:all)
    end
    
    @map = GMap.new("map_div")
    @map.control_init(:large_map => true,:map_type => true)
    if current_user.geo_coords
      @map.center_zoom_init(current_user.geo_coords,4)
    else
      @map.center_zoom_init([75.6,-42.467],4)
    end
    
    for user in @users
      @map.overlay_init(GMarker.new(user.geo_coords, :title => "#{user.first_name} #{user.last_name}", :info_window => "<b>#{user.first_name} #{user.last_name}<br/>#{user.phone}<br/>#{user.email}</b>")) if user.geo_coords
    end
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @users }
    end
  end

  # GET /users/1
  # GET /users/1.xml
  def show
    @user = User.find(params[:id])
    @address = @user.address || Address.new
    
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @user }
    end
  end

  # GET /users/new
  # GET /users/new.xml
  def new
    @user = User.new
    @address = @user.build_address

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @user }
    end
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
    @address = @user.address || @user.build_address
  end

  # POST /users
  # POST /users.xml
  def create
    @user = User.new(params[:user])
    @user.build_address(params[:address])

    respond_to do |format|
      if @user.save
        flash[:notice] = 'User was successfully created.'
        format.html { redirect_to(@user) }
        format.xml  { render :xml => @user, :status => :created, :location => @user }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /users/1
  # PUT /users/1.xml
  def update
    @user = User.find(params[:id])
    @address = @user.address || @user.build_address

    respond_to do |format|
      if @user.update_attributes(params[:user]) && @address.update_attributes(params[:address])
        flash[:notice] = 'User was successfully updated.'
        format.html { redirect_to(@user) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def update_friends
    @user = User.find(params[:id])

    respond_to do |format|
      if @user.update_attributes(params[:user])
        flash[:notice] = 'Your friends were updated successfully.'
        format.html { redirect_to(user_friendships_path(@user)) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  
  end

  # DELETE /users/1
  # DELETE /users/1.xml
  def destroy
    @user = User.find(params[:id])
    @user.destroy

    respond_to do |format|
      format.html { redirect_to(users_url) }
      format.xml  { head :ok }
    end
  end

  private
  def require_admin_or_self
    unless current_user.admin? || current_user == User.find(params[:id])
      flash[:notice] = "You must be an admin to access this page"
      redirect_to users_path
      return false
    end
  end
end

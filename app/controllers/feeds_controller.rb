class FeedsController < ApplicationController
  # We don't want to require a user here, just to view the general feed
  skip_before_filter :require_user
  
  def index
    # Retrieve the list of moves from the Address Change table, to be used by the RSS feed
    @changes = AddressChange.all(:order => 'created_at desc', :limit => 50)
    
    # Use the rss builder to respond to feed requests
    respond_to do |format|
      format.rss # index.rss.builder
    end
  end

end

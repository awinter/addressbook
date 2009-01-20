class FeedsController < ApplicationController
  skip_before_filter :require_user
  
  def index
    @changes = AddressChange.all(:order => 'created_at desc', :limit => 50)
    
    respond_to do |format|
      format.rss # index.rss.builder
    end
  end

end

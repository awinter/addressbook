# Addresses are broken out from users for the following reasons:
#   * Changes in addresses are tracked, not changes in users/friends
#   * Eventually there may be multiple addresses associated with a user, this step takes us down that path
#   * It felt right
class Address < ActiveRecord::Base
  
  # Addresses will cache logitude and latitude. This gem helps with that.
  include Geokit::Geocoders
  
  # Relationships to other models
  belongs_to :user
  has_many :address_changes
  
  # If the address changes, we need to update the longitude and latitude prior to persisting
  before_save :geocode_address
  
  # After persisting, we need to update our table of address changes for use by the RSS feed
  after_save :update_address_changes
  
  # Helper method to nicely construct an address
  def full_address
    addr = String.new
    addr << "#{street1}"
    # yes, handling commas was a pain - I tried about 10 other ways before settling on this.
    # Fortunately, google maps is insanely smart and can take just about anything.
    # But this is also used by the RSS reader, so it needs to work well.
    addr << (addr == "" ? "#{street2}" : ", #{street2}")
    addr << (addr == "" ? "#{city}" : ", #{city}")
    addr << (addr == "" ? "#{state}" : ", #{state}")
    addr << (addr == "" ? "#{zip}" : " #{zip}")
    return addr
  end
  
  private
  def geocode_address
    # Use the Gem to geocode the location of the address.
    location = GoogleGeocoder.geocode(full_address)
    
    # Store the long and lat inside the address model
    if (location.success)
      self.latitude = location.lat
      self.longitude = location.lng
    end
  end

  # If an address changes, store it here in a separate table.
  # Note the simplicty as a result of establishing the has_many relationship
  def update_address_changes
    address_changes.create
  end
end

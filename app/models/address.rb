class Address < ActiveRecord::Base
  include Geokit::Geocoders
  
  belongs_to :user
  
  before_save :geocode_address
  
  private
  def geocode_address
    location = GoogleGeocoder.geocode(full_address)
    if (location.success)
      self.latitude = location.lat
      self.longitude = location.lng
    end
  end

  def full_address
    "#{street1},#{street2},#{city},#{state} #{zip}"
  end
end

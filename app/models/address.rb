class Address < ActiveRecord::Base
  include Geokit::Geocoders
  
  belongs_to :user
  has_many :address_changes
  
  before_save :geocode_address
  
  after_save :update_address_changes
  
  def full_address
    "#{street1},#{street2},#{city},#{state} #{zip}"
  end
  
  private
  def geocode_address
    location = GoogleGeocoder.geocode(full_address)
    if (location.success)
      self.latitude = location.lat
      self.longitude = location.lng
    end
  end

  def update_address_changes
    address_changes.create
  end
end

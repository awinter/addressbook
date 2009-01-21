class Address < ActiveRecord::Base
  include Geokit::Geocoders
  
  belongs_to :user
  has_many :address_changes
  
  before_save :geocode_address
  
  after_save :update_address_changes
  
  def full_address
    addr = String.new
    
    addr << "#{street1}"
    addr << (addr == "" ? "#{street2}" : ", #{street2}")
    addr << (addr == "" ? "#{city}" : ", #{city}")
    addr << (addr == "" ? "#{state}" : ", #{state}")
    addr << (addr == "" ? "#{zip}" : " #{zip}")

    return addr
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

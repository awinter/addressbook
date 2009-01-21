class AddressChange < ActiveRecord::Base
  # Establishing the has_many and belongs_to relationship made this feature very elegant
  belongs_to :address
end

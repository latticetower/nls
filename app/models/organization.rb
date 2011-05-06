class Organization < ActiveRecord::Base
has_many :letters
has_one :organization_detail
end

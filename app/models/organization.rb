class Organization < ActiveRecord::Base
default_scope :order => 'name ASC'
has_many :users

end

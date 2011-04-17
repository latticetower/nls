class Letter < ActiveRecord::Base
belongs_to :letter_state, :foreign_key => "state_id"
has_many :letter_details
end

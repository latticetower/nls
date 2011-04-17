class LetterDetail < ActiveRecord::Base
belongs_to :letter
belongs_to :medicine
belongs_to :boxing_type
belongs_to :measure
belongs_to :manufacturer
belongs_to :country
end

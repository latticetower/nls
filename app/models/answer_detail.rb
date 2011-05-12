class AnswerDetail < ActiveRecord::Base
belongs_to :letter
belongs_to :letter_detail
belongs_to :tactic
end

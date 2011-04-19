class ActionList < ActiveRecord::Base
belongs_to :tactic
belongs_to :answer_detail
end

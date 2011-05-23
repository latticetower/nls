class AnswerDetail < ActiveRecord::Base
belongs_to :letter
belongs_to :letter_detail
belongs_to :tactic
belongs_to :organization

	named_scope :find_by_organization, lambda{ |org| {
	  :conditions => ['organization_id in (?)', org]
	}}
  named_scope :find_by_organization, lambda{ |org| {
	  :conditions => ['organization_id in (?)', org]
	}}
end

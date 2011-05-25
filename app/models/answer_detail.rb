class AnswerDetail < ActiveRecord::Base
belongs_to :letter
belongs_to :letter_detail
belongs_to :organization
belongs_to :tactic
belongs_to :answer
belongs_to :user
belongs_to :supplier
  def to_label
    ld = letter_detail
    ld.medicine.name.to_s unless ld
  end
def authorized_for_create?
  return false if not current_user
  return current_user.is_a_client?
end

def authorized_for_read?
  return false if not current_user
  true
end

def authorized_for_update?
  return false if not current_user
  return current_user.is_a_client?
end
 # validates_presence_of :details, :if => :tactic_decided? , :message => Russian.t(:no_details_msg)
 ##TODO: tactic
  def tactic_decided?
    tactic.group == 1
  end
	named_scope :find_by_organization, lambda{ |org| {
	  :conditions => ['organization_id in (?)', org]
	}}

end

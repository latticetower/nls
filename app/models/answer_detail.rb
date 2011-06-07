class AnswerDetail < ActiveRecord::Base
  belongs_to :letter
  belongs_to :letter_detail
  belongs_to :organization
  belongs_to :tactic
  belongs_to :answer
  belongs_to :user
  belongs_to :supplier

  validates_length_of :details, :minimum => 3,  :if => :tactic_must_have_details? , :message => 'no data'
  def tactic_must_have_details? 
    return ((self.tactic_id == 2) or (self.tactic_id == 3))
  end
 
  
  
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

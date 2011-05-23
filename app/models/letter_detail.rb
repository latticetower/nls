class LetterDetail < ActiveRecord::Base
belongs_to :letter
belongs_to :detail_type
belongs_to :medicine
belongs_to :boxing_type
belongs_to :measure
belongs_to :manufacturer
belongs_to :country
has_many    :answer_details
belongs_to :answer, :primary_key => 'id', :foreign_key => 'letter_id'




  
  def find_answer_by_organization(org)
     AnswerDetail.find(:first, :conditions => {:organization_id => current_user.organization_id, :letter_detail_id => self.id})
  end
  
def authorized_for_read?
  return false if not current_user
  return current_user.active?
 #return current_user.is_a_tehnik?
end

def authorized_for_delete?
  return false if not current_user
 current_user.is_an_operator?
end

def authorized_for_create?
  return false if not current_user
 current_user.is_an_admin_or_operator?
end
end

class LetterDetail < ActiveRecord::Base
  belongs_to :letter
  belongs_to :detail_type
  belongs_to :medicine
  belongs_to :boxing_type
  belongs_to :measure
  belongs_to :manufacturer
  belongs_to :country
  has_many  :answer_details
  

  
  #belongs_to :answer, :primary_key => 'id', :foreign_key => 'letter_id'
  def detail_type_authorized?
    return false unless current_user
    current_user.is_an_admin_or_operator_or_inspector?
  end
  
  ##todo: check all!!
  ##TODO: поковырять
  def make_answer_detail(user_id, answer_id)
   conditions = {:user_id => user_id, 
      :letter_detail_id => self.id, 
      :answer_id => answer_id }
   
     @ad = AnswerDetail.find(:first, :conditions => conditions)
     unless @ad
       @ad = AnswerDetail.find(:first, :conditions => {
          :organization_id => current_user.organization_id, 
      :letter_detail_id => self.id, 
      :letter_id => letter.id})
      if @ad
         @ad.update_attribute(:answer_id, answer_id)
         @ad.update_attribute(:user_id, user_id)
         @ad.save
      end
     end
     
     @ad = AnswerDetail.create(conditions) unless @ad
   @ad.update_attribute(:letter_id, letter.id) if @ad.letter_id == 0
     #end
      return @ad  
  end

  
  def find_answer_by_organization(org)
     AnswerDetail.find(:first, :conditions => {:organization_id => current_user.organization_id, :letter_detail_id => self.id})
  end
  
def authorized_for_read?
  return false if not current_user
  return current_user.active?
 #return current_user.is_a_tehnik?
end
  def create_authorized?
    return false unless current_user
    current_user.is_an_operator?
  end
  
  def update_authorized?
    return false unless current_user
    current_user.is_an_operator_or_inspector?
  end

  
  def delete_authorized?
    return false unless current_user
    current_user.is_an_operator?
  end 
  def authorized_for_delete?
    return false if not current_user
   current_user.is_an_operator?
  end

def authorized_for_create?
  return false if not current_user
 current_user.is_an_admin_or_operator?
end
def authorized_for_update?
  return false if not current_user
 current_user.is_an_admin_or_operator_or_inspector?
end
end

##class is for saving changes in letter_detail status history.
##not used now
class ActionList < ActiveRecord::Base
  belongs_to :tactic
  belongs_to :answer_detail
  
  def authorized_for_read?
     return false unless current_user
     return true
  end
  def authorized_for_update?
    return false unless current_user
    current_user.is_an_operator_or_admin?
  end
  def authorized_for_create?
      return false unless current_user
      current_user.is_an_operator_or_admin?
  end
  def authorized_for_delete?
    return false unless current_user
    current_user.is_an_operator_or_admin?
  end
end

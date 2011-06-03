class DetailType < ActiveRecord::Base
  has_many :letter_details
  def authorized_for_read?
     return false unless current_user
     return true
  end
 ##TODO: create named_scope :by_type
  def authorized_for_update?
    return false unless current_user
    current_user.is_an_operator_or_admin_or_inspector?
  end
  def authorized_for_create?
      return false unless current_user
      current_user.is_an_operator_or_admin_or_inspector?
  end
  def authorized_for_delete?
    return false unless current_user
    current_user.is_an_operator_or_admin?
  end
  
  def authorized?
    return false if not current_user
    current_user.is_an_admin_or_operator?
  end
end

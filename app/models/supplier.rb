class Supplier < ActiveRecord::Base
has_many :answer_details
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

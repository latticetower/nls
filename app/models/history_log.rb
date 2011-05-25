class HistoryLog < ActiveRecord::Base
  def authorized_for_read?
     return false unless current_user
     current_user.is_an_admin?
  end
  def authorized_for_update?
    return false unless current_user
    current_user.is_an_admin?
  end
  def authorized_for_create?
      return false unless current_user
      current_user.is_an_admin?
  end
  def authorized_for_delete?
    return false unless current_user
    current_user.is_an_admin?
  end
end

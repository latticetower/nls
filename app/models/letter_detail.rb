class LetterDetail < ActiveRecord::Base
belongs_to :letter
belongs_to :medicine
belongs_to :boxing_type
belongs_to :measure
belongs_to :manufacturer
belongs_to :country
has_one    :answer_detail
belongs_to :answer, :primary_key => 'id', :foreign_key => 'letter_id'

  def authorized_for_update?
    current_user.is_an_operator_or_admin?
  end
  def authorized_for_create?
    current_user.is_an_operator_or_admin?
  end
  def authorized_for_destroy?
    current_user.is_an_operator_or_admin?
  end
end

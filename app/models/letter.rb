class Letter < ActiveRecord::Base
belongs_to :letter_state, :foreign_key => "state_id"
has_many :letter_details
belongs_to :organization
def to_label
  item
end
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

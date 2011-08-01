class AnswerDetail < ActiveRecord::Base
  belongs_to :letter
  belongs_to :letter_detail
  belongs_to :organization
  belongs_to :tactic
  belongs_to :answer
  belongs_to :user
  belongs_to :supplier
  

named_scope :by_username,
        :include => :supplier,
        :conditions => [ "user_id = ?", User.current_user.id]

   named_scope :published, 
    :select => 'distinct *',
    :joins => 'left join answers on answers.id =answer_details.answer_id',
    :conditions => 'answers.answered=true' 
	
    named_scope :by_printed_users_for, lambda{|sender| {
	:joins => ['left join users on users.id=answer_details.user_id',
	     'left join organizations on organizations.id=users.organization_id',
	     'left join user_organizations on user_organizations.organization_id=organizations.id'],
		 :conditions => ['user_organizations.user_id in (?)', sender]
	}}
	
named_scope :all_received_drugs, :select => 'sum(received_drugs)'

named_scope :all_identified_drugs, :select => 'sum(identified_drugs)'

  named_scope :by_user, lambda {|user_id|{:conditions => {:user_id => user_id}} }
  
  validates_numericality_of :identified_drugs
 validates_numericality_of :received_drugs
  validates_length_of :details, :minimum => 3,  :if => :tactic_must_have_details? , :message => 'no data'
 validates_length_of :supplier_name, :minimum => 3
  
  def tactic_must_have_details? 
    return ((self.tactic_id == 2) or (self.tactic_id == 3))
  end
 
 def check_if_valid?
   flag = true
   if tactic_must_have_details? 
     if details.length < 2
       #flash[:message] << '<br>'
       #flash[:message] << ad.letter_detail.medicine.name + ' '
       #flash[:message] << ad.letter_detail.serial
       #flash[:message] << ' '
       #flash[:message] << Russian.t(:no_data)
       flag = false
     end
   end
   #return ((self.tactic_id == 2) or (self.tactic_id == 3))
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

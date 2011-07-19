# adding table answers
# before was: 
#   class Answer < ActiveRecord:Base ... (etc)
#
class Answer < ActiveRecord::Base
  has_many :letter_details, :through => :letter
  has_many :answer_details #
  belongs_to :letter #
  belongs_to :user #
  has_many :suppliers, :through => :answer_details
  #validates_length_of :details, :minimum => 3,  :if => :tactic_must_have_details? , :message => 'no data'
  #validates_presence_of :user
  
    ##just added named scope
  named_scope :by_users, lambda{ |usrs| {
	  :conditions => ['user_id in (?)', usrs]
	}}
  
  named_scope :not_empty, 
    :select => 'distinct *',
    :joins => 'left join answer_details on answer_details.answer_id = answers.id',
    :conditions => 'answer_details.received_drugs > 0'

  
  accepts_nested_attributes_for :answer_details, :reject_if => :all_blank, :update_only => true, :allow_destroy => true
  accepts_nested_attributes_for :suppliers
  
  def details_validate!
    flag = true
    self.answer_details.each do |ad|
      flag = false if not ad.check_if_valid?
    end
    flag
  end
  
  def make_details(user_id)
    #@letter = self.letter
    #@answer = Answer.find(:user_id => user_id, :letter_id => letter_id)
    #@answer = Answer.new(:user_id => user_id, :letter_id => letter_id) unless @answer
    self.letter_details.each do |ld|
      ld.make_answer_detail(user_id, self.id)
    end
    
    
    #@answer.make_details
   # return @answer
   
  end
end

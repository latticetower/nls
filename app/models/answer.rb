# adding table answers
# before was: 
#   class Answer < ActiveRecord:Base ... (etc)
#
class Answer < ActiveRecord::Base
  has_many :letter_details, :through => :letter
  has_many :answer_details #
  belongs_to :letter #
  belongs_to :user #
  

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

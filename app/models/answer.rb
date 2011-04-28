class Answer < Letter

has_many :letter_details
has_many :answer_details, :through => :letter_details



  
end

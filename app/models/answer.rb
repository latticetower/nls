class Answer < Letter

has_many :letter_details, :foreign_key => "letter_id", :primary_key => 'id'
has_many :answer_details, :foreign_key => "letter_id", :primary_key => 'id'

accepts_nested_attributes_for :letter_details, :answer_details, :letter



  
end

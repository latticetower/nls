module LettersHelper
   def letter_letter_column(detail) 
	h(detail.letter.item) 
   end
   def letter_line_count_column(letter)
   h(letter.letter_details.count)
   end
   def letter_created_on_column(letter)
   letter.created_on.to_s(:date_only)
   end
   def list_row_class(letter)
    letter.answered ? 'answered' : 'new_letter'
  end
end

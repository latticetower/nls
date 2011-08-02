module LetterDetailsHelper

   def madeby_column(detail)
    "#{detail.letter_detail.manufacturer.name}<br>#{detail.letter_detail.country.name}"
   end

end

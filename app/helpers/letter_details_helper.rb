module LetterDetailsHelper
   def letter_detail_boxing_type_column(detail) 
	h(detail.boxing_type.name) 
   end

 def letter_detail_letter_column(detail) 
	h(detail.item) + ' '
	+  h(detail.created_on.strftime("%d.%m.%y"))
   end
   
   def letter_detail_manufacturer_column(detail)
     h(detail.manufacturer.name)
   end
   
   def letter_detail_measure_column(detail)
     (detail.measure.name)
   end
   
   def letter_detail_serial_column(detail)
	in_place_editor_field :letter_detail, 'serial' 
   end
   def letter_detail_details_column(detail)
     h(detail.details)
   end
end

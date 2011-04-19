module AnswerDetailsHelper
 def letter_column(detail) 
	'N' +h(detail.letter.item) + ' ' +  h(detail.letter.created_on.strftime("%d.%m.%y"))
   end

   def letter_detail_column(record) 
   h(record.letter_detail.medicine.name + " " + record.letter_detail.boxing_type.name + 	" " + record.letter_detail.measure.name + 	" " + record.letter_detail.manufacturer.name +	" " + record.letter_detail.country.name  + " " + record.letter_detail.serial) 
   end
 # def manufacturer_form_column(record, options)
    # with date_select we can use :name
    #date_select :record, :date_received, options
    # but if we used select_date we would have to use :prefix
    #select_date record[:date_received], options.merge(:prefix => options[:name])
 # end
   def answer_detail_supplier_column(detail)
     h(detail.supplier)
   end
   
   def answer_detail_manufacturer_column(detail)
  in_place_editor_field :manufacturer, 'name' 
   end
   
   def answer_detail_identified_drugs_column(detail)
	 in_place_editor_field  :identified_drugs, ''
   end
   def answer_detail_details_column(detail)
     h(detail.details)
   end
end

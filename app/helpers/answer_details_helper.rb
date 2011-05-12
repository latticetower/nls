module AnswerDetailsHelper

 def letter_column(detail) 
	'N#{detail.letter.item} #{detail.letter.created_on.strftime("%d.%m.%y")}'
   end
    def item_and_date_column(detail) 
	'N' + h(detail.letter.item) + '<br> ' +  h(detail.letter.created_on.strftime("%d.%m.%y"))
   end

   def letter_detail_all_column(record) 
   "#{record.letter_detail.medicine.name}<br>
      #{record.letter_detail.boxing_type.name}<br>
	  #{record.letter_detail.measure.name}
  "
   end
   

 # def manufacturer_form_column(record, options)
    # with date_select we can use :name
    #date_select :record, :date_received, options
    # but if we used select_date we would have to use :prefix
    #select_date record[:date_received], options.merge(:prefix => options[:name])
 # end
   def serial_column(detail)
     h(detail.letter_detail.serial)
   end
   

 
   
   def boxing_type_column(detail) 
	h(detail.boxing_type.name) 
   end

 def letter_column(detail) 
	h(detail.item) + ' '
	+  h(detail.created_on.strftime("%d.%m.%y"))
   end
   
   def producer_country_column(detail)
    "#{detail.letter_detail.manufacturer.name}<br>#{detail.letter_detail.country.name if detail.letter_detail.country}"
   end
   
   def measure_column(detail)
     (detail.measure.name)
   end
   
end

module AnswerDetailsHelper

 def letter_column(detail) 
	'N#{detail.letter.item} #{detail.letter.created_on.strftime("%d.%m.%y")}'
   end
    def item_and_date_column(detail) 
	'N' + h(detail.letter ? detail.letter.item : "_____") + '<br> ' +  h(detail.letter ? detail.letter.created_on.strftime("%d.%m.%y") : "____")
   end

   def letter_detail_all_column(record) 
   if record.letter_detail
   ld = record.letter_detail
   "#{ld.medicine ? ld.medicine.name : ''}<br>
      #{ld.boxing_type ? ld.boxing_type.name : ''}<br>
	  #{ld.measure ? ld.measure.name : ''}
  "
  end
  ""
   end
   

 # def manufacturer_form_column(record, options)
    # with date_select we can use :name
    #date_select :record, :date_received, options
    # but if we used select_date we would have to use :prefix
    #select_date record[:date_received], options.merge(:prefix => options[:name])
 # end
   def serial_column(detail)
     h(detail.letter_detail ? detail.letter_detail.serial : "")
   end
   

 
   
   def boxing_type_column(detail) 
	h(detail.boxing_type ? detail.boxing_type.name : "") 
   end

 def letter_column(detail) 
	h(detail.item) + ' '
	+  h(detail.created_on.strftime("%d.%m.%y"))
   end
   
   def producer_country_column(detail)
    if detail.letter_detail 
    ld = detail.letter_detail
    "#{ld.manufacturer ? ld.manufacturer.name : ''}<br>#{ld.country ? ld.country.name : ""}"
    end
   end
   
   def measure_column(detail)
     h(detail.measure ? detail.measure.name : '')
   end
   
end

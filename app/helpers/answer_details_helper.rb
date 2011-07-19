module AnswerDetailsHelper

 def answer_detail_letter_column(detail) 
	'N#{detail.letter.item} #{detail.letter.created_on.strftime("%d.%m.%y")}'
   end
   def answer_detail_supplier_form_column
   in_place_editor_field :supplier, :name
   end
 def answer_detail_item_and_date_column(detail) 
    
	@s = 'N' + h(detail.letter ? detail.letter.item : "_____") + '<br> ' 
  return @s unless detail.letter
  id = detail.letter.item_date
  return @s unless id  
  @s+ h(id.strftime("%d.%m.%y"))
   end

   def answer_detail_letter_detail_all_column(ad) 
     ld = ad.letter_detail
     if ld
       return "#{ld.medicine ? ld.medicine.name : ''}<br>
          #{ld.boxing_type ? ld.boxing_type.name : ''}<br>
        #{ld.measure ? ld.measure.name : ''}
      "
    end
    "-"    
   end
   

 # def manufacturer_form_column(record, options)
    # with date_select we can use :name
    #date_select :record, :date_received, options
    # but if we used select_date we would have to use :prefix
    #select_date record[:date_received], options.merge(:prefix => options[:name])
 # end
   def answer_detail_serial_column(detail)
     h(detail.letter_detail ? detail.letter_detail.serial : "")
   end
  
   
   def answer_detail_boxing_type_column(detail) 
	h(detail.boxing_type ? detail.boxing_type.name : "") 
   end

 def answer_detail_letter_column(detail) 
	h(detail.item) + ' '
	+  h(detail.created_on.strftime("%d.%m.%y"))
   end
   
   def answer_detail_producer_country_column(detail)
    if detail.letter_detail 
    ld = detail.letter_detail
    "#{ld.manufacturer ? ld.manufacturer.name : ''}<br>#{ld.country ? ld.country.name : ""}"
    end
   end
   
   def answer_detail_measure_column(detail)
     h(detail.measure ? detail.measure.name : '')
   end

   def answer_detail_medicine_column(detail)
     @ld = detail.letter_detail
     return ''  unless @ld
     h(@ld.medicine ? @ld.medicine.name : '')
   end
   
   def answer_detail_detail_type_column(detail)
   return '' if User.current_user.is_a_client_or_manager?
     return '' unless detail.letter_detail
     return '' unless detail.letter_detail.detail_type
     h(detail.letter_detail.detail_type.name)
   end
end

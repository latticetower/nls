module AnswersHelper
  def letter_column(detail) 
	'N' +h(detail.letter.item) + ' ' +  h(detail.letter.created_on.strftime("%d.%m.%y"))
   end

   def letter_detail_column(record) 
   h(record.letter_detail.medicine.name) 
   end
 # def manufacturer_form_column(record, options)
    # with date_select we can use :name
    #date_select :record, :date_received, options
    # but if we used select_date we would have to use :prefix
    #select_date record[:date_received], options.merge(:prefix => options[:name])
 # end
   def supplier_column(detail)
     h(detail.supplier)
   end
   
   def manufacturer_column(detail)
      in_place_editor_field :manufacturer, 'name' 
   end
   
   def identified_drugs_column(detail)
     in_place_editor_field  :identified_drugs, ''
   end
   def details_column(detail)
     h(detail.details)
   end
   
   def boxing_type_column(detail) 
    h(detail.boxing_type.name) 
   end

 def letter_column(detail) 
	h(detail.item) + ' '
	+  h(detail.created_on.strftime("%d.%m.%y"))
   end
   
   def manufacturer_column(detail)
     h(detail.manufacturer.name)
   end
   
   def measure_column(detail)
     (detail.measure.name)
   end
   
   def serial_column(detail)
	in_place_editor_field :letter_detail, 'serial' 
   end
   def details_column(detail)
     h(detail.details)
   end
end

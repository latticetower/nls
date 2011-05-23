class Letter < ActiveRecord::Base
  belongs_to :letter_state, :foreign_key => "state_id"
  has_many :letter_details
  belongs_to :organization
  
  def to_label
    item
  end
  
   def authorized_for_read?
   return false unless current_user
   return true
    #current_user.is_an_operator_or_admin?
  end
  def authorized_for_update?
  return false unless current_user
    current_user.is_an_operator_or_admin?
  end
    def authorized_for_create?
    return false unless current_user
      current_user.is_an_operator_or_admin?
    end
  def authorized_for_delete?
    return false unless current_user
    current_user.is_an_operator_or_admin?
  end

  
  def to_xml(options={})
    options[:indent] ||= 2
    if options[:builder]
      build_xml(options[:builder])
    else
      xml = Builder::XmlMarkup.new(:indent => options[:indent])
      xml.instruct! :xml, :version=>"1.0", :encoding=>"UTF-8"
      build_xml(xml)
    end
  end
  
private
  def build_xml(xml)
  xml.Answers do
  xml.Organization do
    xml.Name current_user.organization_name
    xml.Phone current_user.phone
    xml.Upoln current_user.upoln_name
    xml.tag!("item_date", item_date, :type => :datetime)
    xml.tag!("created_on", created_on, :type => :datetime)
    xml.item item

    letter_details.each do |ld|
      ad = ld.answer_details.find(:first, :conditions => {:organization_id => current_user.organization_id})
      if ad
        xml.AnswerDetail do
          xml.id ad.id
          xml.item item
          xml.item_date item_date.to_s
          
          @ld = ad.letter_detail
          xml.naim (@ld.medicine ? @ld.medicine.name : '' )
          xml.measure (@ld.measure ? @ld.measure.name : '' )
          xml.boxing_type (@ld.boxing_type ? @ld.boxing_type.name : '')
          xml.manufacturer do 
              xml.name (@ld.manufacturer ? @ld.manufacturer.name : '')
              xml.country (@ld.country ? @ld.country.name : '')
             end
          xml.serial @ld.serial
          xml.seller ad.supplier
          xml.received_drugs ad.received_drugs
          xml.identified_drugs ad.identified_drugs
          xml.Mery ad.tactic ? ad.tactic.name : ''
          xml.Reqv ad.details

        end
        end#of if ad
      end
    end
    end
    end
 

end
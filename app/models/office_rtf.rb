require 'zipruby'
require 'nokogiri'
require 'fileutils'
require 'open-uri'

require "rubygems"
require "rtf"
require 'rtf/utf8'
include RTF

class OfficeRTF

  
  
  def self.do_rtf_for_all(sender, letter)
  
  doc_style = DocumentStyle.new
  doc_style.orientation = DocumentStyle::LANDSCAPE
  doc_style.left_margin = 1100
  doc_style.right_margin = 1100
  doc_style.top_margin = 800
  doc_style.bottom_margin = 800
    document = Document.new(Font.new(Font::ROMAN, 'Times New Roman'), doc_style)
   ## document.paper. << Paper.new('A4_portrait', 16840, 11907)
    #    Create the used styles.
    styles                           = {}
    #10 шрифт, с подчеркиванием - для названия организации
    styles['UNDERLINED']             = CharacterStyle.new
    styles['UNDERLINED'].underline   = true
    styles['UNDERLINED'].font_size = 20
    
    styles['U']             = CharacterStyle.new
    styles['U'].underline   = true
        #10 шрифт, с подчеркиванием - для названия организации
    styles['BOLD']             = CharacterStyle.new
    styles['BOLD'].bold   = true
    styles['BOLD'].font_size = 20
    #14 шрифт, выравнивание по левому краю
    styles['HEADER'] = CharacterStyle.new
    styles['HEADER'].font_size = 28 
    #центрирование
    styles['CENTERED']             = ParagraphStyle.new
    styles['CENTERED'].justification = ParagraphStyle::CENTER_JUSTIFY 
    
    styles['NORMAL']                 = ParagraphStyle.new
    styles['NORMAL'].space_after     = 300
    #отступ - для заголовка
    styles['PS_INDENTED']             = ParagraphStyle.new
    styles['PS_INDENTED'].left_indent = 9000
    document.paragraph(styles['PS_INDENTED']) do |p|
      p.apply(styles['HEADER']) do |s|
          s << Russian.t(:header_line1)
          s.line_break
          s << Russian.t(:header_line2)
          s.line_break
          s << Russian.t(:header_line3)
          s.line_break
          s << Russian.t(:header_line4)
          s.line_break
          s << Russian.t(:header_line5) 
        end
    end  
    document.paragraph
   document.paragraph(styles['CENTERED']) do |p|
      p.apply(styles['HEADER']) do |s|
       s << Russian.t(:letter_title)
      end
    end
    document.paragraph
    document.paragraph(styles['CENTERED']) do |p|
        p << "________________"
         p.apply(styles['UNDERLINED']) do |s|
            s << sender.organization_name
          end 
        p << "________________"
        p.line_break
        p.apply(styles['BOLD']) do |s|
          s << Russian.t(:org_name_title)
        end
      end
document.paragraph
    
    @ads = AnswerDetail.find(:all, :conditions => {
        :organization_id => sender.organization_id, 
        :letter_id => letter.id
        })
    @c = @ads.length
     
    table    = document.table(@c + 1, 9, 500, 2000, 2000, 1500, 1500, 1500, 2000, 2000, 2000)
  table.border_width = 5
  table[0][0] << Russian.t(:tbl_number)
  table[0][1] << Russian.t(:tbl_letter_item)
  table[0][2] << Russian.t(:tbl_ls)
  table[0][3] << Russian.t(:tbl_serial)
  table[0][4] << Russian.t(:tbl_manufacturer)
  table[0][5] << Russian.t(:tbl_seller)
  table[0][6] << Russian.t(:tbl_found)
  table[0][7] << Russian.t(:tbl_mery)
  table[0][8] << Russian.t(:tbl_reqv)

  table[0][1].top_border_width = 10
  @line = 1
  @ads.each do |ad| 
    table [@line][0] << @line.to_s #номер пп
    #table [@line][1] do |t|
      table [@line][1] << letter.item #дата и номер письма
      table [@line][1].line_break
      table [@line][1] << letter.item_date.to_s
    #end
    @ld = ad.letter_detail
    # table [@line][2] do |t| #лс
      table [@line][2] << (@ld.medicine ? @ld.medicine.name : '' )
      table [@line][2].line_break
      table [@line][2] << (@ld.measure ? @ld.measure.name : '' )
      table [@line][2].line_break
      table [@line][2] << (@ld.boxing_type ? @ld.boxing_type.name : '') 
    #end
    #table [@line][3] do |t| #лс
      table [@line][3] << @ld.serial 
    #end
    #table [@line][4] do |t| #лс
      table [@line][4] << (@ld.manufacturer ? @ld.manufacturer.name : '')
      table [@line][4].line_break
      table [@line][4] << (@ld.country ? @ld.country.name : '')
   # end
    #table [@line][5] do |t| #лс
      table [@line][5] << ad.supplier
    #end
    #table [@line][6] do |t| #лс
      table [@line][6] << ad.received_drugs.to_s
      table [@line][6] << '/'
      table [@line][6] << ad.identified_drugs.to_s
    #end
    #table [@line][7] do |t| #лс
      table [@line][7] << (ad.tactic ? ad.tactic.name : '')
   # end
   # table [@line][8] do |t| #лс
      table [@line][8] << ad.details
    #end
    #инкрементация
    @line = @line + 1
  end

  (@c+1).times do |i|     
    9.times do |j|
      table[i][j].style = styles['CENTERED']
    end
  end
    document.paragraph   
    document.paragraph 
document.paragraph do |p|
      p << Russian.t(:upoln)
      p << " "
      p.apply(styles['U']) do |s|
      s << "  "
      s << sender.upoln_name
      s  << "  "
      end
      p << "                "
      p << Russian.t(:mp)
    end
    document.paragraph 
    document.paragraph do |p| 
      p << Russian.t(:contact_phone)
      p << " "
      p.apply(styles['U']) do |s|
        s <<"  "
        s << sender.phone
        s << "  "
      end
    end
    @filename = "#{RAILS_ROOT}/public/resources/#{sender.email}_answer_#{letter.id}.doc"
    File.open(@filename, 'w') {|file| 
    file.write(document.to_rtf)
    }
    return @filename
  end

  ##TODO: объединить действие для массива и единичного объекта в 1 метод
   def self.do_rtf(sender, letters)
  
  doc_style = DocumentStyle.new
  doc_style.orientation = DocumentStyle::LANDSCAPE
  doc_style.left_margin = 1100
  doc_style.right_margin = 1100
  doc_style.top_margin = 800
  doc_style.bottom_margin = 800
    document = Document.new(Font.new(Font::ROMAN, 'Times New Roman'), doc_style)
   ## document.paper. << Paper.new('A4_portrait', 16840, 11907)
    #    Create the used styles.
    styles                           = {}
    #10 шрифт, с подчеркиванием - для названия организации
    styles['UNDERLINED']             = CharacterStyle.new
    styles['UNDERLINED'].underline   = true
    styles['UNDERLINED'].font_size = 20
    
    styles['U']             = CharacterStyle.new
    styles['U'].underline   = true
        #10 шрифт, с подчеркиванием - для названия организации
    styles['BOLD']             = CharacterStyle.new
    styles['BOLD'].bold   = true
    styles['BOLD'].font_size = 20
    #14 шрифт, выравнивание по левому краю
    styles['HEADER'] = CharacterStyle.new
    styles['HEADER'].font_size = 28 
    #центрирование
    styles['CENTERED']             = ParagraphStyle.new
    styles['CENTERED'].justification = ParagraphStyle::CENTER_JUSTIFY 
    
    styles['NORMAL']                 = ParagraphStyle.new
    styles['NORMAL'].space_after     = 300
    #отступ - для заголовка
    styles['PS_INDENTED']             = ParagraphStyle.new
    styles['PS_INDENTED'].left_indent = 9000
    document.paragraph(styles['PS_INDENTED']) do |p|
      p.apply(styles['HEADER']) do |s|
          s << Russian.t(:header_line1)
          s.line_break
          s << Russian.t(:header_line2)
          s.line_break
          s << Russian.t(:header_line3)
          s.line_break
          s << Russian.t(:header_line4)
          s.line_break
          s << Russian.t(:header_line5) 
        end
    end  
    document.paragraph
    document.paragraph(styles['CENTERED']) do |p|
      p.apply(styles['HEADER']) do |s|
       s << Russian.t(:letter_title)
      end
    end
    document.paragraph
    document.paragraph(styles['CENTERED']) do |p|
        p << "________________"
         p.apply(styles['UNDERLINED']) do |s|
            s << sender.organization_name
          end 
        p << "________________"
        p.line_break
        p.apply(styles['BOLD']) do |s|
          s << Russian.t(:org_name_title)
        end
      end
      document.paragraph

     
      table    = document.table(1, 9, 500, 2000, 2000, 1500, 1500, 1500, 2000, 2000, 2000)
      table.border_width = 5
      table[0][0] << Russian.t(:tbl_number)
      table[0][1] << Russian.t(:tbl_letter_item)
      table[0][2] << Russian.t(:tbl_ls)
      table[0][3] << Russian.t(:tbl_serial)
      table[0][4] << Russian.t(:tbl_manufacturer)
      table[0][5] << Russian.t(:tbl_seller)
      table[0][6] << Russian.t(:tbl_found)
      table[0][7] << Russian.t(:tbl_mery)
      table[0][8] << Russian.t(:tbl_reqv)
    @all_lines = 0
          table[0][1].top_border_width = 10
   letters.each do |letter|
      @answer_id = letter.get_answer_id
      @ads = AnswerDetail.find(:all, :conditions => {
          :user_id => sender.id, 
          :answer_id => @answer_id
          })
      @count_empty = @ads.select{|ad| ad.received_drugs == 0}.length
      @ads = @ads.select{|ad| ad.received_drugs > 0}
      @c = @ads.length
      table    = document.table(@c, 9, 500, 2000, 2000, 1500, 1500, 1500, 2000, 2000, 2000)
            table.border_width = 5
      @line = 0
      
      
      @ads.each do |ad| 
        
        
        @all_lines = @all_lines + 1
        
          table [@line][0] << @all_lines.to_s #номер пп
        #table [@line][1] do |t|
          table [@line][1] << letter.item #дата и номер письма
          table [@line][1].line_break
          table [@line][1] << letter.item_date.to_s
        #end
        @ld = ad.letter_detail
        # table [@line][2] do |t| #лс
          table [@line][2] << (@ld.medicine ? @ld.medicine.name : '' )
          table [@line][2].line_break
          table [@line][2] << (@ld.measure ? @ld.measure.name : '' )
          table [@line][2].line_break
          table [@line][2] << (@ld.boxing_type ? @ld.boxing_type.name : '') 
        #end
        #table [@line][3] do |t| #лс
          table [@line][3] << @ld.serial 
        #end
        #table [@line][4] do |t| #лс
          table [@line][4] << (@ld.manufacturer ? @ld.manufacturer.name : '')
          table [@line][4].line_break
          table [@line][4] << (@ld.country ? @ld.country.name : '')
       # end
        #table [@line][5] do |t| #лс
          table [@line][5] << ad.supplier
        #end
        #table [@line][6] do |t| #лс
          table [@line][6] << ad.received_drugs.to_s
          table [@line][6] << '/'
          table [@line][6] << ad.identified_drugs.to_s
        #end
        #table [@line][7] do |t| #лс
          table [@line][7] << (ad.tactic ? ad.tactic.name : '')
       # end
       # table [@line][8] do |t| #лс
          table [@line][8] << ad.details
        #end
        #инкрементация
        @line = @line + 1
        
      end

      (@c).times do |i|     
        9.times do |j|
          table[i][j].style = styles['CENTERED']
        end
      end
      #оооо
      if @ads.length == 0
        #если по письму ответа нет
          table = document.table(1, 3, 500, 2000,  12500)
            table.border_width = 5
          @all_lines = @all_lines + 1
          
          table [0][0] << @all_lines.to_s #номер пп
          table [0][1] << letter.item #дата и номер письма
          table [0][1].line_break
          table [0][1] << letter.item_date.to_s
 
          table [0][2] << Russian.t(:letter_no_answer) 
            table[0][0].style = styles['CENTERED']     
            table[0][1].style = styles['CENTERED']       
          
        else
          if  @count_empty > 0  
            table = document.table(1, 3, 500, 2000,  12500)
            table.border_width = 5
            @all_lines = @all_lines + 1
            
            table [0][0] << @all_lines.to_s #номер пп
            table [0][1] << letter.item #дата и номер письма
            table [0][1].line_break
            table [0][1] << letter.item_date.to_s
   
            table [0][2] << Russian.t(:letter_no_more_answers)  
            table[0][0].style = styles['CENTERED']     
            table[0][1].style = styles['CENTERED']       
          end      
        end
        
     
   end
    document.paragraph   
    document.paragraph 
document.paragraph do |p|
      p << Russian.t(:upoln)
      p << " "
      p.apply(styles['U']) do |s|
      s << "  "
      s << sender.upoln_name
      s  << "  "
      end
      p << "                "
      p << Russian.t(:mp)
    end
    document.paragraph 
    document.paragraph do |p| 
      p << Russian.t(:contact_phone)
      p << " "
      p.apply(styles['U']) do |s|
        s <<"  "
        s << sender.phone
        s << "  "
      end
    end
    @filename = "#{RAILS_ROOT}/public/resources/#{sender.email}_answer_#{letters.id}.doc"
    File.open(@filename, 'w') {|file| 
    file.write(document.to_rtf)
    }
    return @filename
  end
  
  
  ##TODO: объединить действие для массива и единичного объекта в 1 метод
  def self.do_rtf_with_stuff(sender, letters)
    doc_style = DocumentStyle.new
    doc_style.orientation   = DocumentStyle::LANDSCAPE
    doc_style.left_margin   = 1100
    doc_style.right_margin  = 1100
    doc_style.top_margin    = 800
    doc_style.bottom_margin = 800
  
    document = Document.new(Font.new(Font::ROMAN, 'Times New Roman'), doc_style)
    #Create the used styles.
    styles                           = {}
    #10 шрифт, с подчеркиванием - для названия организации
    styles['UNDERLINED']             = CharacterStyle.new
    styles['UNDERLINED'].underline   = true
    styles['UNDERLINED'].font_size = 20
    
    styles['U']             = CharacterStyle.new
    styles['U'].underline   = true
        #10 шрифт, с подчеркиванием - для названия организации
    styles['BOLD']             = CharacterStyle.new
    styles['BOLD'].bold   = true
    styles['BOLD'].font_size = 20
    #14 шрифт, выравнивание по левому краю
    styles['HEADER'] = CharacterStyle.new
    styles['HEADER'].font_size = 32
    styles['HEADER'].bold = true    
    #центрирование
    styles['CENTERED']             = ParagraphStyle.new
    styles['CENTERED'].justification = ParagraphStyle::CENTER_JUSTIFY 
    
    styles['NORMAL']                 = ParagraphStyle.new
    styles['NORMAL'].space_after     = 300
    #отступ - для заголовка
    styles['PS_INDENTED']             = ParagraphStyle.new
    styles['PS_INDENTED'].left_indent = 9000
   
   document.paragraph(styles['CENTERED']) do |p|
      p.apply(styles['HEADER']) do |s|
       s << Russian.t(:controler_letter_falsies)
      end
    end
    
  document.paragraph

     
  table    = document.table(2, 9, 500, 2000, 2000, 1500, 1500, 1500, 2000, 2000, 2000)
  table.border_width = 5
  table[0][1].top_border_width = 10
  table[0][0] << Russian.t(:tbl_number)
  table[0][1] << Russian.t(:tbl_letter_item)
  table[0][2] << Russian.t(:tbl_ls)
  table[0][3] << Russian.t(:tbl_serial)
  table[0][4] << Russian.t(:tbl_manufacturer)
  table[0][5] << Russian.t(:tbl_seller)
  table[0][6] << Russian.t(:tbl_found)
  table[0][7] << Russian.t(:tbl_mery)
  table[0][8] << Russian.t(:tbl_reqv)
      
  9.times do |i|
    table[1][i] << (i + 1).to_s
    table[0][i].style = styles['CENTERED']
    table[1][i].style = styles['CENTERED']
  end
  @all_lines = 0
      
  DetailType.all.each do |dt|
      @ads =  AnswerDetail.find(:all, :joins => [ 
    "left join letter_details on letter_details.id = answer_details.letter_detail_id"],
	  :conditions => ['letter_details.detail_type_id in (?)', dt.id]
    )

      #@ads = AnswerDetail.find(:all, :conditions => {
      #      :organization_id => sender.organization_id,  
      #      :letter_id => 3 })
      @c = @ads.length
      #название группы ЛС
      table    = document.table(1, 1, 15000)
      table.border_width = 5
      table[0][0] << dt.name_long
      table[0][0].style = styles['CENTERED']
      ##сами ЛС в этой группе
      
      table = document.table(@c, 9, 500, 2000, 2000, 1500, 1500, 1500, 2000, 2000, 2000)
      table.border_width = 5
      @line = 0
      @ads.each do |ad| 
      letter = ad.letter
        
      @all_lines = @all_lines + 1
        table [@line][0] << @all_lines.to_s #номер пп
       # #table [@line][1] do |t|
        table [@line][1] << letter.item #дата и номер письма
        table [@line][1].line_break
        table [@line][1] << letter.item_date.to_s
        ##end
        @ld = ad.letter_detail
        ## table [@line][2] do |t| #лс
          table [@line][2] << (@ld.medicine ? @ld.medicine.name : '' )
         table [@line][2].line_break
          table [@line][2] << (@ld.measure ? @ld.measure.name : '' )
          table [@line][2].line_break
          table [@line][2] << (@ld.boxing_type ? @ld.boxing_type.name : '') 
        ##end
        ##table [@line][3] do |t| #лс
          table [@line][3] << @ld.serial 
        ##end
        ##table [@line][4] do |t| #лс
          table [@line][4] << (@ld.manufacturer ? @ld.manufacturer.name : '')
          table [@line][4].line_break
          table [@line][4] << (@ld.country ? @ld.country.name : '')
       ## end
        ##table [@line][5] do |t| #лс
          table [@line][5] << ad.supplier
        ##end
        ##table [@line][6] do |t| #лс
          table [@line][6] << ad.received_drugs.to_s
          table [@line][6] << '/'
          table [@line][6] << ad.identified_drugs.to_s
        ##end
        ##table [@line][7] do |t| #лс
          table [@line][7] << (ad.tactic ? ad.tactic.name : '')
       ## end
       ## table [@line][8] do |t| #лс
          table [@line][8] << ad.details
        ##end
        ##инкрементация
        @line = @line + 1
        
    #  end

     # (@c).times do |i|     
     #   9.times do |j|
     #     table[i][j].style = styles['CENTERED']
     #   end
    end
   end
    document.paragraph   
    document.paragraph 
    document.paragraph do |p|
      p << Russian.t(:upoln)
      p << " "
      p.apply(styles['U']) do |s|
      s << "  "
      s << sender.upoln_name
      s  << "  "
      end
      p << "                "
      p << Russian.t(:mp)
    end
    document.paragraph 
    document.paragraph do |p| 
      p << Russian.t(:contact_phone)
      p << " "
      p.apply(styles['U']) do |s|
        s <<"  "
        s << sender.phone
        s << "  "
      end
    end
    @filename = "#{RAILS_ROOT}/public/resources/#{sender.email}_answer.doc"
    File.open(@filename, 'w') {|file| 
    file.write(document.to_rtf)
    }
    return @filename
  end
end
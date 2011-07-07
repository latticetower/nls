require 'zipruby'
require 'nokogiri'
require 'fileutils'
require 'open-uri'

require "rubygems"
require "rtf"
require 'rtf/utf8'
include RTF

class OfficeRTF

  
  def self.set_styles
    styles = {}

        #10 �����, � �������������� - ��� �������� �����������
    styles['UNDERLINED 10']             = CharacterStyle.new
    styles['UNDERLINED 10'].underline   = true
    styles['UNDERLINED 10'].font_size = 20
    
    styles['U']             = CharacterStyle.new
    styles['U'].underline   = true
        #10 �����, � �������������� - ��� �������� �����������
    styles['BOLD 10'] = CharacterStyle.new
    styles['BOLD 10'].bold   = true
    styles['BOLD 10'].font_size = 20
    #14 �����, ������������ �� ������ ����
    styles['HEADER 16'] = CharacterStyle.new
    styles['HEADER 16'].font_size = 32 
    
    styles['HEADER 14'] = CharacterStyle.new
    styles['HEADER 14'].font_size = 28 
    
    styles['HEADER BOLD 14'] = CharacterStyle.new
    styles['HEADER BOLD 14'].font_size = 28
    styles['HEADER BOLD 14'].bold = true  
    
    styles['BOLD'] = CharacterStyle.new
    styles['BOLD'].bold   = true    
    #�������������
    styles['CENTERED']             = ParagraphStyle.new
    styles['CENTERED'].justification = ParagraphStyle::CENTER_JUSTIFY 
    
    styles['NORMAL']                 = ParagraphStyle.new
    styles['NORMAL'].space_after     = 300
    #������ - ��� ���������
    styles['PS_INDENTED']             = ParagraphStyle.new
    styles['PS_INDENTED'].left_indent = 9000
    return styles
  end
  
  def self.set_doc_style
    doc_style = DocumentStyle.new
    doc_style.orientation = DocumentStyle::LANDSCAPE
    doc_style.left_margin = 1100
    doc_style.right_margin = 1100
    doc_style.top_margin = 800
    doc_style.bottom_margin = 800
    return doc_style
  end
  def self.do_rtf_1(sender, letters)
    self.do_rtf_with_stuff(sender, letters)
  end
  
  def self.do_rtf_2(sender, letters)
    self.do_rtf_tu(sender, letters)
  end
  
  def self.do_rtf_for_all(sender, letter)
  
    doc_style = set_doc_style
    document = Document.new(Font.new(Font::ROMAN, 'Times New Roman'), doc_style)
   ## document.paper. << Paper.new('A4_portrait', 16840, 11907)
    #    Create the used styles.
    styles = set_styles

    document.paragraph(styles['PS_INDENTED']) do |p|
      p.apply(styles['HEADER 14']) do |s|
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
      p.apply(styles['HEADER 14']) do |s|
       s << Russian.t(:letter_title)
      end
    end
    document.paragraph
    document.paragraph(styles['CENTERED']) do |p|
        p << "________________"
        p.apply(styles['UNDERLINED 10']) do |s|
            s << sender.organization_name
        end 
        p << "________________"
        p.line_break
        p.apply(styles['BOLD 10']) do |s|
          s << Russian.t(:org_name_title)
        end
    end
    document.paragraph
    
    @ads = AnswerDetail.find(:all, :conditions => {
        :organization_id => sender.organization_id, 
        :letter_id => letter.id})
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
    table [@line][0] << @line.to_s #����� ��
    #table [@line][1] do |t|
      table [@line][1] << letter.item #���� � ����� ������
      table [@line][1].line_break
      table [@line][1] << letter.item_date.to_s
    #end
    @ld = ad.letter_detail
    # table [@line][2] do |t| #��
      table [@line][2] << (@ld.medicine ? @ld.medicine.name : '' )
      table [@line][2].line_break
      table [@line][2] << (@ld.measure ? @ld.measure.name : '' )
      table [@line][2].line_break
      table [@line][2] << (@ld.boxing_type ? @ld.boxing_type.name : '') 
    #end
    #table [@line][3] do |t| #��
      table [@line][3] << @ld.serial 
    #end
    #table [@line][4] do |t| #��
      table [@line][4] << (@ld.manufacturer ? @ld.manufacturer.name : '')
      table [@line][4].line_break
      table [@line][4] << (@ld.country ? @ld.country.name : '')
   # end
    #table [@line][5] do |t| #��
      table [@line][5] << ad.supplier
    #end
    #table [@line][6] do |t| #��
      table [@line][6] << ad.received_drugs.to_s
      table [@line][6] << '/'
      table [@line][6] << ad.identified_drugs.to_s
    #end
    #table [@line][7] do |t| #��
      table [@line][7] << (ad.tactic ? ad.tactic.name : '')
   # end
   # table [@line][8] do |t| #��
      table [@line][8] << ad.details
    #end
    #�������������
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
    File.open(@filename, 'w') {|file| file.write(document.to_rtf) }
    return @filename
  end

  ##TODO: ���������� �������� ��� ������� � ���������� ������� � 1 �����
   def self.do_rtf(sender, letters)
  
    doc_style = set_doc_style
    document = Document.new(Font.new(Font::ROMAN, 'Times New Roman'), doc_style)
   ## document.paper. << Paper.new('A4_portrait', 16840, 11907)
    #    Create the used styles.
    styles = set_styles
    #10 �����, � �������������� - ��� �������� �����������
    
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
      if not letter.answered 
      @answer_id = letter.get_answer_id
      @ads = AnswerDetail.find(:all, :conditions => {:user_id => sender.id, 
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
        
          table [@line][0] << @all_lines.to_s #����� ��
        #table [@line][1] do |t|
          table [@line][1] << letter.item #���� � ����� ������
          table [@line][1].line_break
          table [@line][1] << letter.item_date.to_s
        #end
        @ld = ad.letter_detail
        # table [@line][2] do |t| #��
          table [@line][2] << (@ld.medicine ? @ld.medicine.name : '' )
          table [@line][2].line_break
          table [@line][2] << (@ld.measure ? @ld.measure.name : '' )
          table [@line][2].line_break
          table [@line][2] << (@ld.boxing_type ? @ld.boxing_type.name : '') 
        #end
        #table [@line][3] do |t| #��
          table [@line][3] << @ld.serial 
        #end
        #table [@line][4] do |t| #��
          table [@line][4] << (@ld.manufacturer ? @ld.manufacturer.name : '')
          table [@line][4].line_break
          table [@line][4] << (@ld.country ? @ld.country.name : '')
       # end
        #table [@line][5] do |t| #��
          table [@line][5] << (ad.supplier ? ad.supplier.name : ad.supplier_name)
        #end
        #table [@line][6] do |t| #��
          table [@line][6] << ad.received_drugs.to_s
          table [@line][6] << '/'
          table [@line][6] << ad.identified_drugs.to_s
        #end
        #table [@line][7] do |t| #��
          table [@line][7] << (ad.tactic ? ad.tactic.name : '')
       # end
       # table [@line][8] do |t| #��
          table [@line][8] << ad.details
        #end
        #�������������
        @line = @line + 1
        
      end

      (@c).times do |i|     
        9.times do |j|
          table[i][j].style = styles['CENTERED']
        end
      end
      #����
      if @ads.length == 0
        #���� �� ������ ������ ���
          table = document.table(1, 3, 500, 2000,  12500)
          table.border_width = 5
          @all_lines = @all_lines + 1
          
          table [0][0] << @all_lines.to_s #����� ��
          table [0][1] << letter.item #���� � ����� ������
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
            
            table [0][0] << @all_lines.to_s #����� ��
            table [0][1] << letter.item #���� � ����� ������
            table [0][1].line_break
            table [0][1] << letter.item_date.to_s
   
            table [0][2] << Russian.t(:letter_no_more_answers)  
            table[0][0].style = styles['CENTERED']     
            table[0][1].style = styles['CENTERED']       
          end      
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
 
  
  
  def self.print_table_header1(document, styles)
    table = document.table(2, 9, 500, 2000, 2000, 1500, 1500, 1500, 2000, 2000, 2000)
    table.border_width = 5
    table[0][1].top_border_width = 10
    table[0][0].apply(styles['BOLD']) << Russian.t(:tbl_number)
    table[0][1].apply(styles['BOLD']) << Russian.t(:tbl_letter_item)
    table[0][2].apply(styles['BOLD']) << Russian.t(:tbl_ls)
    table[0][3].apply(styles['BOLD']) << Russian.t(:tbl_serial)
    table[0][4].apply(styles['BOLD']) << Russian.t(:tbl_manufacturer)
    table[0][5].apply(styles['BOLD']) << Russian.t(:tbl_company)
    table[0][6].apply(styles['BOLD']) << Russian.t(:tbl_seller)
    table[0][7].apply(styles['BOLD']) << Russian.t(:tbl_found)
    table[0][8].apply(styles['BOLD']) << Russian.t(:tbl_mery_0)
      
    9.times do |i|
      table[1][i].apply(styles['BOLD']) << (i + 1).to_s
      table[0][i].style = styles['CENTERED']
      table[1][i].style = styles['CENTERED']
    end
  end
 
  def self.print_table_header2(document, styles)
    table = document.table(2, 9, 500, 2000, 2000, 1500, 1500, 1500, 2000, 2000, 2000)
    table.border_width = 5
    table[0][1].top_border_width = 10
    table[0][0].apply(styles['BOLD']) << Russian.t(:tbl_number)
    table[0][1].apply(styles['BOLD']) << Russian.t(:tbl_letter_item)
    table[0][2].apply(styles['BOLD']) << Russian.t(:tbl_ls)
    table[0][3].apply(styles['BOLD']) << Russian.t(:tbl_serial)
    table[0][4].apply(styles['BOLD']) << Russian.t(:tbl_manufacturer)
    table[0][5].apply(styles['BOLD']) << Russian.t(:tbl_company)
    table[0][6].apply(styles['BOLD']) << Russian.t(:tbl_seller)
    table[0][7].apply(styles['BOLD']) << Russian.t(:tbl_found)
    table[0][8].apply(styles['BOLD']) << Russian.t(:tbl_mery)
    9.times do |i|
      table[1][i].apply(styles['BOLD']) << (i + 1).to_s
      table[0][i].style = styles['CENTERED']
      table[1][i].style = styles['CENTERED']
    end 
  end
  
  def self.print_header1(document, styles, starts_at, ends_at)
    document.paragraph(styles['CENTERED']) do |p|
       p.apply(styles['HEADER BOLD 14']) do |s|
        s << Russian.t(:controler_letter_falsies)
        s.line_break
        s << Russian.t(:rep_from)
        s << Russian::strftime(starts_at.to_date, Russian.t(:quote_format))
        s << Russian.t(:rep_to)
        s << Russian::strftime(ends_at.to_date, Russian.t(:quote_format))
      end
    end
    document.paragraph
  end
  
  def self.print_header2(document, styles)
    document.paragraph
    document.paragraph(styles['CENTERED']) do |p|
      p.apply(styles['HEADER BOLD 14']) do |s|
       s << Russian.t(:letter_title_nedobro)
       s.line_break
       s << Russian.t(:rep_from)
       s << Russian::strftime(starts_at.to_date, Russian.t(:quote_format))
       s << Russian.t(:rep_to)
       s << Russian::strftime(ends_at.to_date, Russian.t(:quote_format)) 
      end
    end
    document.paragraph
    document.paragraph
  end
  
  def self.prepare_detail_type_header(document, styles, dt)
      table = document.table(1, 1, 15000)
      table.border_width = 5
      table[0][0].apply(styles['BOLD']) << dt.name_long
      table[0][0].style = styles['CENTERED']
  end
  
  def self.print_letter_line1(document, styles, table, line, all_lines, letter, ld, ad)
    table[line][0] << all_lines.to_s #����� ��
    
    table[line][1] << (letter ? letter.item : '') #���� � ����� ������
    table[line][1].line_break
    table[line][1] << (letter ? letter.item_date.to_s : '')
            ##end
    @ld = ad.letter_detail
            ## table [@line][2] do |t| #��
    table[line][2] << (ld.medicine ? ld.medicine.name : '' )
    table[line][2].line_break
    table[line][2] << (ld.measure ? ld.measure.name : '' )
    table[line][2].line_break
    table[line][2] << (ld.boxing_type ? ld.boxing_type.name : '') 

    table[line][3] << ld.serial 
    if ld.allow_serial_input 
      table[line][3].line_break
      table[line][3] << (ad ? ad.serial : '')
    end
    table[line][4] << (ld.manufacturer ? ld.manufacturer.name : '')
    table[line][4].line_break
    table[line][4] << (ld.country ? ld.country.name : '')
    if ad
      table[line][5] << (ad.user ? ad.user.organization_name : '')
      if ad.received_drugs > 0          
        table[line][6] << ad.supplier
        table[line][7] << ad.received_drugs.to_s
        table[line][7] << '/'
        table[line][7] << ad.identified_drugs.to_s 
        table[line][8] << (ad.tactic ? ad.tactic.name : '')
        table[line][8].line_break
      
        table[line][8] << ad.details
      else
        table[line][7] << Russian.t(:letter_no_answer)
      end
    end


  end
  
  
  
  def self.print_letter_line2(document, styles, all_lines, letter, ld, ad)
    table = document.table(1, 9, 500, 2000, 2000, 1500, 1500, 1500, 2000, 2000, 2000)
    table.border_width = 5
    @all_lines = all_lines + 1           
    @line = 0 
    table [@line][0] << @all_lines.to_s #����� ��
    table [@line][1] << letter.item #���� � ����� ������
    table [@line][1].line_break
    table [@line][1] << letter.item_date.to_s
               #@ld = ad.letter_detail
    table [@line][2] << (ld.medicine ? ld.medicine.name : '' )
    table [@line][2].line_break
    table [@line][2] << (ld.measure ? ld.measure.name : '' )
    table [@line][2].line_break
    table [@line][2] << (ld.boxing_type ? ld.boxing_type.name : '') 

    table [@line][3] << ld.serial 
    if ld.allow_serial_input 
      table[@line][3].line_break
      table[@line][3] << (ad ? ad.serial : '')
    end
    
      table [@line][4] << (ld.manufacturer ? ld.manufacturer.name : '')
      table [@line][4].line_break
      table [@line][4] << (ld.country ? ld.country.name : '')
    if ad
        table [@line][5] << (ad.user ? ad.user.organization_name : '')
      if ad.received_drugs > 0   
        table [@line][6] << (ad.supplier ? ad.supplier.name : ad.supplier_name)
    
        table [@line][7] << ad.received_drugs.to_s
        table [@line][7] << '/'
        table [@line][7] << ad.identified_drugs.to_s
        table [@line][8] << (ad.tactic ? ad.tactic.name : '')
        table [@line][8].line_break
        table [@line][8] << ad.details
      else 
        table [@line][7] << Russian.t(:letter_no_answer)
      end
    end
    9.times do |j|
      table[@line][j].style = styles['CENTERED']
    end
    return @all_lines
  end
  
  
  ###
  def self.print_organization_line(document, styles, all_lines, org)
    table = document.table(1, 9, 500, 2000, 2000, 1500, 1500, 1500, 2000, 2000, 2000)
    table.border_width = 5
    @all_lines = all_lines + 1           
    @line = 0 
    table [@line][0] << @all_lines.to_s #����� ��
    table [@line][1] << org.name #���� � ����� ������
    
    9.times do |j|
      table[@line][j].style = styles['CENTERED']
    end
    return @all_lines
  end
 
  
  ##TODO: ���� ��������� �������� ��� �������, � ������
  def self.print_empty_line1(document, styles, all_lines, letter, ld)
    table = document.table(1, 9, 500, 2000, 2000, 1500, 1500, 1500, 2000, 2000, 2000)
    table.border_width = 5
    @line = 0
      ##for every letter
    @all_lines = all_lines + 1
    table [@line][0] << @all_lines.to_s #����� ��
      # #table [@line][1] do |t|
    table[@line][1] << letter.item #���� � ����� ������
    table[@line][1].line_break
    table[@line][1] << letter.item_date.to_s
    table[@line][2] << (ld.medicine ? ld.medicine.name : '' )
    table[@line][2].line_break
    table[@line][2] << (ld.measure ? ld.measure.name : '' )
    table[@line][2].line_break
    table[@line][2] << (ld.boxing_type ? ld.boxing_type.name : '') 
    table[@line][3] << ld.serial 
    table[@line][4] << (ld.manufacturer ? ld.manufacturer.name : '')
    table[@line][4].line_break
    table[@line][4] << (ld.country ? ld.country.name : '')
              
    table[@line][5] << ''
    table[@line][6] << ''
    table[@line][7] << Russian.t(:letter_no_answer)
    table[@line][8] << ''
    return @all_lines
  end
  
  
  
  
  def self.print_empty_line2(document, styles, all_lines, letter)
    table = document.table(1, 3, 500, 2000,  12500)
    table.border_width = 5
    @all_lines = all_lines + 1
            
    table [0][0] << @all_lines.to_s #����� ��
    table [0][1] << letter.item #���� � ����� ������
    table [0][1].line_break
    table [0][1] << letter.item_date.to_s
   
    table [0][2] << Russian.t(:letter_no_answer) 
    table[0][0].style = styles['CENTERED']     
    table[0][1].style = styles['CENTERED']     
    return @all_lines
  end
  
  def self.print_table_footer1(document, styles)
    document.paragraph   
    document.paragraph 
    table = document.table(1, 3, 4500, 8000,2000)
            table.border_width = 0
    table[0][0] << Russian.t(:rukovoditel_tu1)
    table[0][0].line_break
    table[0][0] << Russian.t(:rukovoditel_tu2)
    table[0][0].line_break
    table[0][0] << Russian.t(:rukovoditel_tu3)    

    table[0][2] << Russian.t(:rukovoditel_tu_fio)
  end
  
  def self.print_table_footer2(document, styles)    
    document.paragraph   
    document.paragraph 
    table = document.table(1, 3, 4500, 8000,2000)
    table.border_width = 0
    
    table[0][0] << Russian.t(:rukovoditel_tu1)
    table[0][0].line_break
    table[0][0] << Russian.t(:rukovoditel_tu2)
    table[0][0].line_break
    table[0][0] << Russian.t(:rukovoditel_tu3)    

    table[0][2] << Russian.t(:rukovoditel_tu_fio)
  end
  
  ##TODO: ����� ������ ������ ������. ����������� � �����!!!!
  def self.do_rtf_group1(sender, starts_at, ends_at, rgroup, rtype)
    @letters = Letter.by_dates(starts_at, ends_at) 
     
 
    doc_style = set_doc_style
    document = Document.new(Font.new(Font::ROMAN, 'Times New Roman'), doc_style)
    styles = set_styles 
    
    print_header1(document, styles, starts_at, ends_at)
    print_table_header1(document, styles)

    @all_lines = 0
 
    ##TODO: ������ ������ �������  
    DetailType.find_all_by_group(rgroup).each do |dt|
      prepare_detail_type_header(document, styles, dt)
      #TODO: check conditions!
      #@letters = letters #Letter.find(:all,# :conditions => ['item_date between ? and ?', #     1.month.ago.beginning_of_month.to_date, #     1.month.ago.end_of_month.to_date], #  :order =>'item_date ASC, item ASC' )
      @letters.each do |letter|
        ##TODO: �������� named_scope
        @lds = letter.letter_details.by_detail_type(dt.id)
       
       #����������� � ���? �� ������� ���-�� �������, � �������� ������ � ����� ������ �� �������. �.�. �� ��� �� ������� ���� ��������� �� ��������
        @lds.each do |ld| 
          @ads = ld.answer_details
          @count_empty = @ads.select{|ad| ad.received_drugs == 0}.length
          @ads = @ads.select{|ad| ad.received_drugs > 0 and ad.letter}
          @ads_empty = @ads.select{|ad|   ad.received_drugs == 0}
          
          ##TODO: ���� �������� ������� �� ������
          @c = @ads.length 
          table = document.table(@c, 9, 500, 2000, 2000, 1500, 1500, 1500, 2000, 2000, 2000)
          table.border_width = 5
          @line = 0
          ##for every letter
          @ads.each do |ad|   #letter = ad.letter          #next if not letter  
            @all_lines = @all_lines + 1
            print_letter_line1(document, styles, table, @line, @all_lines, letter, ld, ad)
            ##�������������
            @line = @line + 1
          end
          #��� ������ �����#
          if rtype == "full"
            @ads_empty.each do |ad|   #letter = ad.letter          #next if not letter  
              @all_lines = @all_lines + 1
              print_letter_line1(document, styles, table, @line, @all_lines, letter, ld, ad)
              ##�������������
              @line = @line + 1
            end
          end
          #  (@c).times do |i|             #    9.times do |j|#      table[i][j].style = styles['CENTERED']#    end#  end
          if @ads.length == 0
            @line = 0
            @all_lines = print_empty_line1(document, styles, @all_lines, letter, ld)
            ##������������� - � ������� ���� �� �����
            @line = @line + 1     
          end
        end ##lds
      end ##@letters.each
      ##after
    end ##DetailType
    print_table_footer1(document, styles)

    @filename = "#{RAILS_ROOT}/public/resources/#{sender.email}_answer.doc"
    File.open(@filename, 'w') {|file| file.write(document.to_rtf) }
    return @filename
 end
 
 ##TODO: �������� �������, �������� �������������� � ������
 def self.do_rtf_group2(sender, starts_at, ends_at, rgroup, rtype)
    @letters = Letter.by_dates(starts_at, ends_at) ##.by_group(rgroup) 
    
    doc_style = set_doc_style
    document = Document.new(Font.new(Font::ROMAN, 'Times New Roman'), doc_style)
    styles = set_styles
 
    #10 �����, � �������������� - ��� �������� �����������
    #������ 14 �����, �� ������
    print_header1(document, styles, starts_at, ends_at)
    print_table_header2(document, styles)  
    
    @all_lines = 0  
    #1.month.ago.end_of_month.to_date], :order => 'item_date ASC, item ASC')
    ###���� ������� �� �����������       
    DetailType.find_all_by_group(rgroup).each do |dt|
      @letters.each do |letter|
           @ld = letter.letter_details.by_detail_type(dt.id)
           @counter = 0
           @count_not_empty = 0
           @ld.each do |ld|
             @ads = ld.answer_details
             @count_not_empty = @ads.select{|ad| ad.received_drugs > 0}.length
             @count_empty  = @ads.select{|ad| ad.received_drugs == 0}.length
             @empty_ads = @ads.select{|ad| ad.received_drugs == 0}
             @ads = @ads.select{|ad| ad.received_drugs > 0}
             @counter = @counter + @count_not_empty
             @c = @ads.length
             @ads.each do |ad| 
                @all_lines = print_letter_line2(document, styles, @all_lines, letter, ld, ad) 
             end
             if rtype == "full" and @count_empty > 0
               @empty_ads.each do |ad|
                 @all_lines = print_letter_line2(document, styles, @all_lines, letter, ld, ad) 
               end
             end
           end
           if @counter == 0 and rtype != "full"
              #���� �� ������ ������ ���
              @all_lines = print_empty_line2(document, styles, @all_lines, letter)
                
          end
      end
      ##!!!!!!!!!!!
    end  
    print_table_footer2(document, styles)
    
    @filename = "#{RAILS_ROOT}/public/resources/#{sender.email}_answer.doc"
    File.open(@filename, 'w') {|file| file.write(document.to_rtf) }
    return @filename
  end
  
  
  ##
   def self.do_rtf_organizations(sender, starts_at, ends_at, rtype, rgroup)    
    doc_style = set_doc_style
    document = Document.new(Font.new(Font::ROMAN, 'Times New Roman'), doc_style)
    styles = set_styles

    print_header1(document, styles, starts_at, ends_at)
    print_table_header2(document, styles)  
    
    @all_lines = 0  
    #1.month.ago.end_of_month.to_date], :order => 'item_date ASC, item ASC')
    ###���� ������� �� �����������       
    @orgs = sender.printed_organizations
    @orgs.each do |org|
      @all_lines = print_organization_line(document, styles, @all_lines, org) 
    end
 
    print_table_footer2(document, styles)
    
    @filename = "#{RAILS_ROOT}/public/resources/#{sender.email}_answer.doc"
    File.open(@filename, 'w') {|file| file.write(document.to_rtf) }
    return @filename
  end
  
  ####
   def self.do_rtf_medicines(sender, starts_at, ends_at, rtype, rgroup)
    @letters = Letter.by_dates(starts_at, ends_at) ##.by_group(rgroup) 
    
    doc_style = set_doc_style
    document = Document.new(Font.new(Font::ROMAN, 'Times New Roman'), doc_style)
    styles = set_styles
    #print_header1(document, styles, starts_at, ends_at)
    @all_lines = 0  
    #1.month.ago.end_of_month.to_date], :order => 'item_date ASC, item ASC')

    DetailType.find(:all).each do |dt|
      prepare_detail_type_header(document, styles, dt)

      @letters.each do |letter|
        @ld = letter.letter_details.by_detail_type(dt.id)
        @ld.each do |ld|
          @all_lines = print_letter_line2(document, styles, @all_lines, letter, ld, nil) 
        end
      end
    end  
    
    @filename = "#{RAILS_ROOT}/public/resources/#{sender.email}_medicines.doc"
    File.open(@filename, 'w') {|file| file.write(document.to_rtf) }
    return @filename
  end
end
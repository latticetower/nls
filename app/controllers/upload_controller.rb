require 'data_file'


class UploadController < ApplicationController
  def initialize
    
  end

  def index
    render :file=> 'app\\views\\uploadfile.rhtml'
  end

  def uploadfile
  return if not params[:id]
    mime_type = 
      "application/vnd.openxmlformats-
      officedocument.wordprocessingml.document"
    #### - {RAILS_ROOT}
    DataFile.save("#{RAILS_ROOT}/public/data/roszdrav.xslt", "#{RAILS_ROOT}/public/data/roszdrav.docx", params[:id]
    #'public/data/roszdrav.xml'
    ) if params[:id]
    
    # Send the new file with the wordprocessingml document
    # content type.
    send_file("#{RAILS_ROOT}/public/resources/newdoc.docx", :filename => "newdoc.docx", :type => mime_type)
  end
  def uploaddoc
  return if not params[:id]
    mime_type = 
          "application/msword"
     @letter = Letter.find(params[:id]) if params[:id]
  @user = current_user
  @file = DataFile.do_rtf(@user, [@letter])
    # Send the new file with the wordprocessingml document
    # content type.
    send_file(@file, :filename => Russian.t(:letter) + "N" +
  @letter.item.inspect + " - " + @letter.item_date.to_s + ".doc", :type => mime_type)

  end
  
  def print_controler
  @letters = Letter.find(:all)
  render :xml => @letters.to_xml
    mime_type = "application/msword"
  @user = current_user
  @file = DataFile.do_rtf_with_stuff(@user, @letters)
    # Send the new file with the wordprocessingml document
    # content type.
  send_file(@file, :filename => Russian.t(:letters) + " - " + Time.now.to_s + ".doc", :type => mime_type)

end
  def uploadmarked
    return if not params[:id]
    mime_type = 
          "application/msword"
     @letter = Letter.find(params[:id]) if params[:id]
  @user = current_user
  @file = DataFile.do_rtf(@user, @letter)
    # Send the new file with the wordprocessingml document
    # content type.
    send_file(@file, :filename => Russian.t(:letter) + "N" +
  @letter.item.inspect + " - " + @letter.item_date.to_s + ".doc", :type => mime_type)

  end
  def xmlp
   mime_type = 
      "application/msword"
  #@letter = Letter.find(3)
  #@user = current_user
  #@file = DataFile.do_rtf(@user, @letter)
  #send_file(@file, :filename => Russian.t(:letter) + "N" +
  #@letter.item.inspect + " - " + @letter.item_date.to_s + ".doc", :type => mime_type)
file = "public/text.csv"
File.open(file, "w"){ |f| f << "Hello World!" }
send_file(file, :type => "text/csv; charset=utf-8")
  #render :nothing => true
      #render :xml => Letter.find(3).to_xml
end
 
end
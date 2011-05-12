require 'data_file'
class UploadController < ApplicationController
  def initialize
    
  end

  def index
    render :file=> 'app\\views\\uploadfile.rhtml'
  end

  def uploadfile
    mime_type = 
      "application/vnd.openxmlformats-
      officedocument.wordprocessingml.document"
    
    DataFile.save('#{RAILS_ROOT}/public/data/roszdrav.xslt','#{RAILS_ROOT}/public/data/roszdrav.docx','#{RAILS_ROOT}/public/data/roszdrav.xml')
    
    # Send the new file with the wordprocessingml document
    # content type.
    send_file("#{RAILS_ROOT}/public/resources/newdoc.docx", :filename => "newdoc.docx", :type => mime_type)
  end
 
end
class DataFile
  def initialize
  end

  # Save the uploaded files to a temp folder and then perform
  # translation.
  #we don't need this
=begin
  def self.save(upload,upload1,upload2)
    name =
      sanitize_filename(upload['file'].original_filename).to_s
    name1 =
      sanitize_filename(upload1['file1'].original_filename).to_s
    name2 =
      sanitize_filename(upload2['file2'].original_filename).to_s

    directory = "public\\data\\"

    # Create the file path.
    path = File.join(directory, name).to_s
    path1 = File.join(directory,name1).to_s
    path2 = File.join(directory,name2).to_s
    
    # Save the files.
    upload_file(path,upload,'file')
    upload_file(path1,upload1,'file1')
    upload_file(path2,upload2,'file2')
#main method
    OfficeOpenXML.translate(path,
                            path1,
                            path2,
                            "public\\resources\\newdoc.docx")
  end
=end  
   # Save the uploaded files to a temp folder and then perform
  # translation.
  #we don't need this
  def self.save(xslt,template,xml)
    
    OfficeOpenXML.translate(xslt,
                            template,
                            xml,
                            "#{RAILS_ROOT}/public/resources/newdoc.docx")
  end
  
  def self.do_rtf(sender, answers)
    
    return OfficeRTF.do_rtf(sender, answers)
  end
  
  def self.do_rtf_with_stuff(sender, answers)
  
    return OfficeRTF.do_rtf_with_stuff(sender, answers)
  end

  def self.do_rtf_for_tu(sender, starts_at, ends_at, rtype, rgroup,rgt) 
    return OfficeRTF.do_rtf_group1(sender, starts_at, ends_at, rgroup, rtype) if rgt == "1"
    return OfficeRTF.do_rtf_group2(sender, starts_at, ends_at, rgroup, rtype)
  end
  
  #stub
  def self.do_rtf_medicines(sender, starts_at, ends_at, rtype, rgroup,rgt) 
    return OfficeRTF.do_rtf_medicines(sender, starts_at, ends_at, rtype, rgroup) 
   
  end
  def self.do_rtf_organizations(sender, starts_at, ends_at, rtype, rgroup,rgt) 
    return OfficeRTF.do_rtf_organizations(sender, starts_at, ends_at, rtype, rgroup)
  end
  ##TODO: remove this method
  def self.do_rtf_for_tudd(sender, letters, rtype, rgroup)
  
    return OfficeRTF.do_rtf_1(sender, letters)
  end
  
  def self.do_rtf_for_tu2(sender, answers)
  
    return OfficeRTF.do_rtf_2(sender, answers)
  end
  private
  def self.upload_file(path,uploadfile,file)
    File.open(path, "wb") do |f|
    f.write(uploadfile[file].read)
    end
  end

  private
  def self.sanitize_filename(file_name)
    # Get only the filename, not the whole path.
    just_filename = File.basename(file_name)
    # Replace all non-alphanumeric, underscore or period characters
    # with an underscore.
    just_filename.gsub(/[^\w\.\_]/,'_')
  end

end
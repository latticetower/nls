require 'zipruby'
require 'nokogiri'
require 'fileutils'
require 'open-uri'


class OfficeOpenXML

  def self.translate(xslt, template, xml, newdoc)
    new(xslt, template, xml, newdoc).translate
  end

  def initialize(xslt, template, xml, newdoc)
    # Store the instance variables.
    @xslt, @template, @xml, @newdoc = xslt, template, xml, newdoc
  end

  def translate
    wordprocessingml_schema =
      "http://schemas.openxmlformats.org/wordprocessingml/2006/main"
    
    # Get the contents of the main document part from the
    # template document.
    existing_xml = get_from_template("word/document.xml")
    
    # Get the w:body node.
    body_node = existing_xml.root.xpath(
      "w:body", {"w" => wordprocessingml_schema}).first
    
    # Clear the contents of the document by removing all child nodes 
    # of the w:body element of the template document.
    body_node.children.unlink
    
    # Add each w:body child node from the new transformed XML to the
    # body of the template document.
    new_xml.xpath(
      "*/w:body",
      {"w" => wordprocessingml_schema}).first.children.each do
        |child| body_node.add_child(child) end
    
    # Save the template document as a new document.
    compress(existing_xml)
  end

  def get_from_template(filename)
    # Retrieve the contents of the main document part from the
    # template document.
    xml = Zip::Archive.open(@template) do |zipfile|
      zipfile.fopen(filename).read
    end
    
    # Parse the resulting XML into a Nokogiri XML document.
    Nokogiri::XML.parse(xml)
  end

  def new_xml
    # Transform the values from the XML data file.
    stylesheet_doc.transform(Nokogiri::XML(Letter.find(@xml).to_xml))
  end

  def compress(newXML)
    # Copy the modified template document to a new document.
    FileUtils.copy(@template, @newdoc)
      File.open("#{RAILS_ROOT}/log/observers.log", 'a') {|f| 
      f.write("compress " + @newdoc + "  template:" + @template + "\r\n") 
      }
 
    # Open the new document as a ZIP archive.
    Zip::Archive.open(@newdoc, Zip::CREATE) do |zipfile|
      # Replace the contents of the main document part of the new
      # document with the new transformed XML.
      zipfile.add_or_replace_buffer('word/document.xml',
        newXML.to_s)
            File.open("#{RAILS_ROOT}/log/observers.log", 'a') {|f| 
    f.write("zip opened \r\n") 
    }
    end
  end
  def self.do_rtf
    document = Document.new(Font.new(Font::ROMAN, 'Times New Roman'))
    document.paragraph << Russian.t(:organization) 
    document.paragraph << "new"
    File.open("#{RAILS_ROOT}/public/resources/my_new_document.rtf", 'a') {|file| file.write(document.to_rtf)}
  end

  def stylesheet_doc
@file = File.open(@xslt)
      File.open("#{RAILS_ROOT}/log/observers.log", 'a') {|f| 
    f.write("xslt template file: " + @xslt + "\r\n") 
    f.write("xslt found\r\n")  if @file
    }
    
    # Parse the XSLT file into a Nokogiri XSLT document.
    Nokogiri::XSLT.parse(@file)
  end
end
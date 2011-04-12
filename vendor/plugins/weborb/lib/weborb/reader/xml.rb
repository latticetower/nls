# =========================================================================
# xml.rb
# Copyright (C) 2006 Midnight Coders, LLC
#
# ruby adaptation, design and implementation: 
#      Harris Reynolds (harris@themidnightcoders.com)
# original design: 
#      Mark Piller (mark@themidnightcoders.com)
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#
# The software is licensed under the GNU General Public License (GPL)
# For details, see http://www.gnu.org/licenses/gpl.txt.
# =========================================================================

require 'weborb/io/binary_reader'
require 'weborb/formats/parse_context'
require 'rexml/document'

class XmlType

  def initialize( document )
    @document = document
  end
  
  def default_adapt
    @document
  end 

end

class XmlReader

  def read( reader, parse_context )
    length = reader.read_integer
    xml_string = reader.read_string( length )
    document = REXML::Document.new xml_string
	document
  end
end

class V3XmlReader

  def read( reader, parse_context )
    length = reader.read_var_integer
    return parse_context.get_reference( length >> 1 ) if( (length & 0x1) == 0 )
    length = length >> 1
    xml_string = reader.read_utf( length )
    document = REXML::Document.new xml_string
	parse_context.add_reference( document )
	document
  end
end

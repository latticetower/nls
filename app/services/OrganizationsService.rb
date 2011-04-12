require 'weborb/context'
require 'rbconfig'

class OrganizationsService  
  def get_organizations
    session = RequestContext.get_session
	@user = session[:user] 
	return nil if  @user.nil?
	#if @user.is_admin? or @user.is_tehnik? 
	  @organizations = Organization.find(:all)
#	else
 #   @organizations = Organization.find(:all, :conditions => {:id => @user.organization_id})
#	end
	return @organizations.to_xml(:dasherize => false)
  end
 
end
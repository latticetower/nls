require 'weborb/context'
require 'rbconfig'

class RolesService  
  def get_roles
    session = RequestContext.get_session
	@user = session[:user] 
	if not @user.can_manage_users?
	   return "<error><code>2</code><message>No access</message></error>"
    end
    @roles = Role.all
	return @roles.to_xml
  end
 
end
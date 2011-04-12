require 'weborb/context'
require 'rbconfig'

class UsersService  
  def get_users
    #session = RequestContext.get_session
	#@user = session[:user] 
    @users = User.find(:all)
	return @users.to_xml(:dasherize => false, :skip_types => true, :skip_instruct => true, :except => [:password, :last_sync] ) 
  end
 
end
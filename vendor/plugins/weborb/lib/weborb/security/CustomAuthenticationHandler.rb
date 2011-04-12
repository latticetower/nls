require 'weborb/security/weborb_security'

class CustomAuthenticationHandler 
 
  def check_credentials(userid, password)
    #WebORBSecurity.check_credentials( userid, password)
	@user = User.find(:first, :conditions => {:login => userid, :password => password})
	raise "Invalid password" if @user.nil? 
	#session = RequestContext.get_session
	#session[:user] = user
	#session[:user_id] = user.id
    true
  end
  
  def init
   #base.init
   for u in User.find(:all)
    #base.add_user(u.login, u.password, u.role.typename)
   end
  end
  
end
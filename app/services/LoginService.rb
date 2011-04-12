require 'weborb/context'
require 'rbconfig'

class LoginService
  def login(username, password)
    session = RequestContext.get_session
	
	session[:user_id] = nil
	session[:user] = nil
    @user = User.authenticate(username, password)
	
	File.open("log***REMOVED***ons.log", 'a') do |f| 
	    f.write("____new connect on weborb___________________\r\n") 
		f.write("" + Time.now.localtime.to_s + "\r\n") 
		f.write("login:" + username + "\r\n") 
		f.write("login:" + password + "\r\n") 
		f.write("----!authenticated \r\n") if @user.nil?
		f.write("_______________________\r\n") 
	end
	
      if @user != nil
        session[:user_id] = @user.id
		session[:user] = @user
		RequestContext.set_session(session)
		return "<error><code>0</code><text>All fine</text></error>"
       else
        return "<error><code>1</code><text>Wrong password</text></error>"
       end
  end
  
  def logout
  session[:user_id] = nil
  end
end
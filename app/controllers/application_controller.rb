class ApplicationController < ActionController::Base
 # helper :all # include all helpers, all the time
 # protect_from_forgery # See ActionController::RequestForgeryProtection for details  
 ##before_filter :jquery_noconflict

#include ExceptionNotification::Notifiable
## def jquery_noconflict
##   ActionView::Helpers::PrototypeHelper.const_set(:JQUERY_VAR, 'jQuery')
## end
  
  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password
def current_user

 User.find(session[:user_id]) if session[:user_id]
end 

#ActiveScaffold.set_defaults do |config|
 # config.dhtml_history = false
# config.security.default_permission = false

#end

 private 
def authorize
  unless (User.find_by_id(session[:user_id])) then
     flash[:notice] = "Please log in"
     
	 respond_to do |format|
      format.html {redirect_to :controller => "login", :action => "login"}
      format.xml  {redirect_to :controller => "login", :action => "login_xml", :format => :xml}
    end
  end
  
end

def render_to_pdf(options = nil)
  data = render_to_string(options)
  pdf = PDF::HTMLDoc.new
  pdf.set_option :bodycolor, :white
  pdf.set_option :toc, false
  pdf.set_option :portrait, true
  pdf.set_option :links, false
  pdf.set_option :webpage, true
  pdf.set_option :left, '2cm'
  pdf.set_option :right, '2cm'
  pdf << Iconv::iconv('cp1251', 'utf8', data).join
  pdf.generate
end

end
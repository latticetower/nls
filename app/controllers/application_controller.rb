class ApplicationController < ActionController::Base
  include Clearance::Admin
  include Clearance::Authentication
  
  before_filter :jquery_noconflict
  
  def jquery_noconflict
    ActionView::Helpers::PrototypeHelper.const_set(:JQUERY_VAR, 'jQuery')
  end
  
  ActiveScaffold.set_defaults do |config|
 # config.dhtml_history = false
# config.security.default_permission = false

  end


=begin
  def current_user
    User.find(session[:user_id])
  end 
=end
=begin
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
=end
  
 # helper :all # include all helpers, all the time
 # protect_from_forgery # See ActionController::RequestForgeryProtection for details
end
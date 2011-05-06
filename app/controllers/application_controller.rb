class ApplicationController < ActionController::Base
layout 'letters'

  before_filter :authorize
  before_filter :jquery_noconflict
  
  def jquery_noconflict
    ActionView::Helpers::PrototypeHelper.const_set(:JQUERY_VAR, 'jQuery')
  end
  
  ActiveScaffold.set_defaults do |config|
	 # config.dhtml_history = false
	# config.security.default_permission = false
  end

    def current_user
      User.find(session[:user_id])
    end 
 

 private 
  def authorize
     unless (User.find_by_id(session[:user_id])) then
      flash[:notice] = "Please log in" #TODO: mb some Russian?
	   respond_to do |format|
       format.html {redirect_to :controller => "login", :action => "login"}
      end
   end
 end
 
  
 # helper :all # include all helpers, all the time
 # protect_from_forgery # See ActionController::RequestForgeryProtection for details
end
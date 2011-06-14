class ApplicationController < ActionController::Base
layout 'letters', :only => 'index'

  before_filter :authorize, :jquery_noconflict
  
  def jquery_noconflict
    ActionView::Helpers::PrototypeHelper.const_set(:JQUERY_VAR, 'jQuery')
  end
  
  ActiveScaffold.set_defaults do |config|
  config.frontend = :farma
	 # config.dhtml_history = false
	# config.security.default_permission = falseconfig.security.default_permission = false
  end

    def current_user
      User.find(session[:user_id])
    end 
 

 private 
  def authorize
     @user = User.find_by_id(session[:user_id])
      unless (@user) then
        flash[:notice] = "Please log in" #TODO: mb some Russian?
        respond_to do |format|
          format.html {redirect_to :controller => "login", :action => "login"}
        end 
       end 
      if @user 
      if @user.active == false 
         flash[:notice] = "Inactive account" 
	      respond_to do |format|
            format.html {redirect_to :controller => "login", :action => "inactive_account"}
          end
      end 
   end
  end
 
  
 # helper :all # include all helpers, all the time
 # protect_from_forgery # See ActionController::RequestForgeryProtection for details
end
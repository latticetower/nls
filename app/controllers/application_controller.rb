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
 # helper :all # include all helpers, all the time
 # protect_from_forgery # See ActionController::RequestForgeryProtection for details
end
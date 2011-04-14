class ApplicationController < ActionController::Base
  include Clearance::Admin
  include Clearance::Authentication
 # helper :all # include all helpers, all the time
 # protect_from_forgery # See ActionController::RequestForgeryProtection for details
end
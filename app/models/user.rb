class User < ActiveRecord::Base
  include Clearance::Admin::User
  include Clearance::User
  

  def authenticate(username, password)
    return nil  unless user = find_by_email(username)
    return user if     user.authenticated?(password)
  end
end

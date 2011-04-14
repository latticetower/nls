class User < ActiveRecord::Base
  include Clearance::Admin::User
  include Clearance::User
end

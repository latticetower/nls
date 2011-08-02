module UsersHelper
 def user_registered_at_column(user)
   return " " unless user.registered_at
   h(user.registered_at.to_s)
   end
   
 
end

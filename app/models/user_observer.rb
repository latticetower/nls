class UserObserver < ActiveRecord::Observer
	def after_create(usr)
	   #emails = User.cin_user_emails
		#RoboMailer.deliver_welcome_email(["***REMOVED***","***REMOVED***"], usr)
     rescue Exception => ex
	#File.open("/var/www/localhost/apps/nls/log/observers.log", 'a') {|f| f.write("error: user_message_observer " + Time.now.to_s() + '  ' + ex.message + "\r\n") }
    end
end

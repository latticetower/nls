class RoboMailer < ActionMailer::Base
	def welcome_email(emails, usr)
		recipients    emails
		from          "robocap@1gb.ru"
		subject Russian.t(:new_user)
		sent_on Time.now
		body  :usr => usr
    end
	
	def ticket_email(emails, ticket)
		recipients    emails
		from          "robocap@***REMOVED***"
		subject Russian.t(:ticket_message) + ' ('+ ticket.categories_list + ') - ' + (ticket.user ? ticket.user.fio : '') 
		sent_on Time.now
		body  :ticket => ticket
    end
	
	def newfile_email(emails, fileman)
		recipients    emails
		from          "robocap@***REMOVED***"
		subject Russian.t(:file_message)
		sent_on Time.now
		body  :filemanager => fileman
		if fileman.file_file_name 
		  attachment :content_type => fileman.file_content_type, :body => File.read('public/images/filemanagers/files/original_' + fileman.file_file_name)
		end
		rescue Exception => ex
        # logger.warn(ex.message)
    end
end

require 'weborb/context'
require 'rbconfig'

class TicketsService  
  def get_tickets
    session = RequestContext.get_session
	@user = session[:user] 
	return nil if @user.nil?
    return @user.show_data()
  end

  def get_firm_tickets
   session = RequestContext.get_session
	@user = session[:user] 
	return @user.show_firm()
  end
  
  def get_personal_tickets
   session = RequestContext.get_session
	@user = session[:user] 
     return @user.show_personal()
  end
  
  def get_ticket_comments(id)
  @ticket = Ticket.find(:first, :conditions => {:id => id})
  @ticket.comments
  end
  
  def update_tickets(tickets)
    upd_tickets = Array.new
    tickets.each do |ticket|
	@author =  User.find(:first, :conditions => {:login => ticket.author})
    if ticket.remoteid.to_s == "0"
	    @ticket = Ticket.create(
		   :text => "#{ticket.text.unpack('m*').to_s().unpack('M*').to_s()}", 
	       :created_by => @author.id, 
		   #:done_by => 0, 
		   :created_at => ticket.created_at,
		   :updated_at => ticket.updated_at, 
		   :organization_id => ticket.organization_id)
		 # @ticket = Ticket.new
	     #ticket.remoteid = @ticket.id.to_s	
	   else
	     @ticket = Ticket.find(:first, :conditions => {:id => ticket.remoteid})
	     Ticket.update(ticket.remoteid, 
	
		 :updated_at => ticket.updated_at 
		 
		 )	 if @ticket
	   end
	   
	   upd_tickets.push({:id => ticket.uid, :ticket => @ticket}) 
	   
    end
    upd_tickets
  end
  
  def update_ticket_comments(ticket_id, comments)
  #File.open("log/tips.log", 'a') {|f| f.write("++dat"+ ticket_id.to_s+"\r\n") }
    upd_comments = Array.new
	@ticket = Ticket.find_by_id(ticket_id)
	return nil if @ticket.nil?
    comments.each do |comment|
	@author = User.find(:first, :conditions => {:login => comment.author})
       if comment.remoteid.to_s == "0"
	     @comment = Comment.create(
		   :text => "#{comment.text.unpack('m*').to_s().unpack('M*').to_s()}", 
		    :author_id => @author.id,
			:ticket_id => @ticket.id
			)
	   else
	     @comment = Comment.find(:first, :conditions => {:id => comment["remoteid"]})
		
	     Comment.update(comment["remoteid"], 
		 
		 :updated_at => comment.updated_at, 
		 :ticket_id => @ticket.id
		 )	 if @comment
	   end
	#File.open("log/tips.log", 'a') {|f| f.write("++dat=="+ comment.ticket_id.to_s+"\r\n") }
	   
	   upd_comments.push({:id => comment.uid, :comment => @comment}) if @comment
	   
    end
    upd_comments
  end
 
end
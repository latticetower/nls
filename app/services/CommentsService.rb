require 'weborb/context'
require 'rbconfig'

class CommentsService  
  def get_ticket_comments(id)
    session = RequestContext.get_session
	@user = session[:user] #дальше д.б. проверка того, что юзер может смотреть тикет
	
    #@user = User.find(:all)
	@ticket = Ticket.find(id)
	return "<error><code>5</code><text>No ticket found</text></error>" if @ticket.nil?
	return @ticket.comments.to_xml(:dasherize => false)
  end
 
end
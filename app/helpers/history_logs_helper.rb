module HistoryLogsHelper
  def history_log_created_at_column(detail) 
	h(detail.created_at.to_s) 
   end
end

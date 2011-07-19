class HistoryLogsController < ApplicationController
  active_scaffold :history_log do |config|
      config.label = Russian.t(:history_logs)
      config.columns = [:created_at, :email, :allowed]
      config.list.columns = [:created_at, :email, :allowed]
    config.actions = [:list, :search]
    ##todo: use this 
    config.columns.each do |column|
      column.label = Russian.t(column.name)
    end
    
    config.list.sorting = {:created_at => 'ASC'}
    
    config.search.columns = [:email]
    config.search.live = true
    
    config.list.per_page = 20

    config.list.always_show_search = true

  end 
  
  def create_authorized?
    return false unless current_user
    current_user.is_an_admin?
  end
  
  def update_authorized?
    return false unless current_user
    current_user.is_an_admin?
  end
  
  def delete_authorized?
    return false unless current_user
    current_user.is_an_admin?
  end 
  
  def list_authorized?
    return false unless current_user
   # current_user.is_an_operator_or_admin?
   true
  end
  
  def conditions_for_collection
    return [] if current_user.is_an_admin_or_operator?
    ['1 != 2']
  end

protected
  # POST /history_logs
  # POST /history_logs.xml
  def create
    @history_log = HistoryLog.new(params[:history_log])

    respond_to do |format|
      if @history_log.save
        format.html { redirect_to(@history_log, :notice => 'HistoryLog was successfully created.') }
        format.xml  { render :xml => @history_log, :status => :created, :location => @history_log }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @history_log.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /history_logs/1
  # PUT /history_logs/1.xml
  def update
    @history_log = HistoryLog.find(params[:id])

    respond_to do |format|
      if @history_log.update_attributes(params[:history_log])
        format.html { redirect_to(@history_log, :notice => 'HistoryLog was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @history_log.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /history_logs/1
  # DELETE /history_logs/1.xml
  def destroy
    @history_log = HistoryLog.find(params[:id])
    @history_log.destroy

    respond_to do |format|
      format.html { redirect_to(history_logs_url) }
      format.xml  { head :ok }
    end
  end
end

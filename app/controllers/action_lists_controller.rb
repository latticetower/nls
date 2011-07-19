class ActionListsController < ApplicationController
 
 active_scaffold  do |config|
    config.label = Russian.t(:action_lists)
    config.actions.exclude :search #temporarily - since there is no action lists now
    config.columns = [:answer_detail, :created_at, :tactic]
    config.list.columns = [:answer_detail, :created_at, :tactic]
    config.columns.each do |column|
       column.label = Russian.t(column.name)
    end
  end
  
  def create_authorized?
    return false unless current_user
    current_user.is_an_operator_or_admin?
  end
  def update_authorized?
    return false unless current_user
    current_user.is_an_operator_or_admin?
  end
  def delete_authorized?
    return false unless current_user
    current_user.is_an_operator_or_admin?
  end
  
  # GET /action_lists/1
  # GET /action_lists/1.xml
  def show
    @action_list = ActionList.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @action_list }
    end
  end

  # GET /action_lists/new
  # GET /action_lists/new.xml
  def new
    @action_list = ActionList.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @action_list }
    end
  end

  # GET /action_lists/1/edit
  def edit
    @action_list = ActionList.find(params[:id])
  end

  # POST /action_lists
  # POST /action_lists.xml
  def create
    @action_list = ActionList.new(params[:action_list])

    respond_to do |format|
      if @action_list.save
        format.html { redirect_to(@action_list, :notice => 'ActionList was successfully created.') }
        format.xml  { render :xml => @action_list, :status => :created, :location => @action_list }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @action_list.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /action_lists/1
  # PUT /action_lists/1.xml
  def update
    @action_list = ActionList.find(params[:id])

    respond_to do |format|
      if @action_list.update_attributes(params[:action_list])
        format.html { redirect_to(@action_list, :notice => 'ActionList was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @action_list.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /action_lists/1
  # DELETE /action_lists/1.xml
  def destroy
    @action_list = ActionList.find(params[:id])
    @action_list.destroy

    respond_to do |format|
      format.html { redirect_to(action_lists_url) }
      format.xml  { head :ok }
    end
  end
end

class AnswerDetailsController < ApplicationController

 active_scaffold :answer_details do |config|
    config.label = Russian.t(:answer_details)
    config.columns = [ :item_and_date, :letter_detail_all, :serial, :producer_country, :supplier, :received_drugs, 	
    :identified_drugs, :tactic, :details]
    config.list.columns =  [ :item_and_date, :letter_detail_all, :serial, :producer_country, :supplier, :received_drugs, 
    :identified_drugs, :tactic,  :details]
  
    config.actions.exclude :create
    config.columns[:supplier].inplace_edit = true
    config.columns[:letter_detail]
    config.columns[:letter_detail].clear_link
    config.columns[:identified_drugs].inplace_edit = true
  
    config.columns[:received_drugs].inplace_edit = true
    config.columns[:tactic].inplace_edit = true
    config.columns[:tactic].form_ui = :select
    config.columns[:details].inplace_edit = true
    ##todo: use this 
    config.columns.each do |column|
       column.label = Russian.t(column.name)
    end	
    config.list.sorting = {:letter => 'ASC'}
    
    config.search.columns = [:letter]
    config.search.live = true
    config.show.link = false
    config.update.link = false
    config.delete.link = false

    config.list.per_page = 15
    config.columns[:letter].sort = true
    config.columns[:letter].sort_by :sql => 'answer_details.letter_id'
    
    config.list.always_show_search = true
  end 
def authorized_for_create?
  return false if not current_user
  return current_user.is_a_client?
end
def authorized_for_read?
  return false if not current_user
  true
end

def list_authorized?
  return false if not current_user
  return true
end
  # GET /answer_details/1
  # GET /answer_details/1.xml
  def show
    @answer_detail = AnswerDetail.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @answer_detail }
    end
  end



  # GET /answer_details/1/edit
  def edit
    @answer_detail = AnswerDetail.find(params[:id])
  end

  # POST /answer_details
  # POST /answer_details.xml
  def create
    @answer_detail = AnswerDetail.new(params[:answer_detail])

    respond_to do |format|
      if @answer_detail.save
        format.html { redirect_to(@answer_detail, :notice => 'AnswerDetail was successfully created.') }
        format.xml  { render :xml => @answer_detail, :status => :created, :location => @answer_detail }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @answer_detail.errors, :status => :unprocessable_entity }
      end
    end
  end


  # PUT /answer_details/1
  # PUT /answer_details/1.xml
  def update
    @answer_detail = AnswerDetail.find(params[:id])

    respond_to do |format|
      if @answer_detail.update_attributes(params[:answer_detail])
        format.html { redirect_to(@answer_detail, :notice => 'AnswerDetail was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @answer_detail.errors, :status => :unprocessable_entity }
      end
    end
  end

  # GET /letter_details/new
  # GET /letter_details/new.xml
  def new
    @answer_detail = AnswerDetail.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @answer_detail }
    end
  end

  # DELETE /answer_details/1
  # DELETE /answer_details/1.xml
=begin
  def destroy
    @answer_detail = AnswerDetail.find(params[:id])
    @answer_detail.destroy

    respond_to do |format|
      format.html { redirect_to(answer_details_url) }
      format.xml  { head :ok }
    end
  end
=end
  end

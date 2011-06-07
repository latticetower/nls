class AnswerDetailsController < ApplicationController
  auto_complete_for :supplier, :name 
  
  active_scaffold :answer_details do |config|
    config.label = Russian.t(:answer_details)
    config.columns = [:detail_type, :item_and_date, :letter_detail_all, :serial, :producer_country, :supplier_name, :received_drugs, 	
    :identified_drugs, :tactic, :details]
    config.list.columns =  [  :detail_type, :item_and_date, :letter_detail_all, :serial, :producer_country, :supplier_name, :received_drugs, 
    :identified_drugs, :tactic,  :details]
  
    config.actions.exclude :create
    config.columns[:supplier_name].inplace_edit = true
   # config.columns[:supplier].form_ui = :select
   # config.columns[:letter_detail]
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
    config.columns[:supplier_name].label = Russian.t(:supplier)
    config.list.sorting = {:letter => 'ASC'}
    
    #config.search.columns = [:serial]
    #config.columns[:serial].search_sql = 'letter_details.serial'
    #config.columns[:letter_detail_all].search_sql = 'medicines.name'
    config.search.live = false
    config.actions.exclude :search
    config.show.link = false
    config.update.link = false
    config.delete.link = false

    config.list.per_page = 15
    config.columns[:letter].sort = true
    config.columns[:letter].sort_by :sql => 'answer_details.letter_id'
    
    config.list.always_show_search = false
  end 

 
def list_authorized?
  return false if not current_user
  return true
end
def detail_type_authorized?
  return false if not current_user
  return false if current_user.is_a_client_or_manager?
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
  
  ## TODO : обработать случай с контролером, который видит ответы по всем организациям и пользователям
  def conditions_for_collection
    return false unless current_user
    return ['answer_details.user_id in (?)', current_user.id]
  end

  # GET /answer_details/1/edit
  def edit
    @answer_detail = AnswerDetail.find(params[:id])
  end

  # POST /answer_details
  # POST /answer_details.xml
  def create
    if params['supplier'] && !params['supplier']['name'].blank?  
      @supplier = Supplier.find_by_name(params['supplier']['name'])  
      @supplier = Supplier.create(:name => params['supplier']['name'] ) if @supplier.nil? 
    end  
    super
  end

private  
  def before_create_save(record)  
    record.supplier_id = @supplier.id if @supplier
  end 
  def before_update_save(record)  
    record.supplier_id = @supplier.id if @supplier
  end  
public
  # PUT /answer_details/1
  # PUT /answer_details/1.xml
  def update
    if params['supplier'] && !params['supplier']['name'].blank?  
      @supplier = Supplier.find_by_name(params['supplier']['name'])  
      @supplier = Supplier.create(:name => params['supplier']['name'] ) if @supplier.nil? 
    end 
    super
  end
=begin
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

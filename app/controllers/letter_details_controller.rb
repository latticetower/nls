class LetterDetailsController < ApplicationController
  auto_complete_for :medicine, :name  
  auto_complete_for :measure, :name 
  auto_complete_for :manufacturer, :name  
  auto_complete_for :country, :name  
  auto_complete_for :boxing_type, :name 
  auto_complete_for :detail_type, :name 
    before_filter :update_table_config

  def update_table_config         
    if current_user
      # Change things one way
      if not current_user.is_an_admin_or_operator?
        active_scaffold_config.columns.exclude :detail_type
      end
    else
      # Change things back the other way
    end 
  end
 
active_scaffold :letter_details do |config|
    config.label = Russian.t(:letter_details)
    config.columns = [ :medicine, :boxing_type, :measure,  :manufacturer,  :country, 
    :serial, :detail_type]
  	##todo: use this 
     config.nested.label = ''
     config.show.label = ''
     config.create.label = Russian.t(:create_label)
	config.columns.each do |column|
	   column.label = Russian.t(column.name)
	end
		
	config.columns[:boxing_type].sort_by :sql => "boxing_type.name"
	config.columns[:manufacturer].sort_by :sql => "manufacturer.name"
#	config.columns[:boxing_type].search_sql = "boxing_type.name"
	config.columns[:manufacturer].search_sql = "manufacturer.name"
  config.columns[:medicine].search_sql = "medicine.name"
  
	config.list.sorting = {:letter => 'ASC'}
	
	config.columns[:medicine].inplace_edit = :ajax
	config.columns[:medicine].form_ui = :select
		
	config.columns[:boxing_type].inplace_edit = :ajax
	config.columns[:boxing_type].form_ui = :select
  
  
  config.columns[:detail_type].inplace_edit = :ajax
	config.columns[:detail_type].form_ui = :select
  config.columns[:detail_type].options = {:include_blank => Russian.t('empty')}
	
	config.columns[:measure].inplace_edit = true
	config.columns[:measure].form_ui = :select
  config.columns[:measure].options = {:include_blank => Russian.t('empty')}
	
	config.columns[:manufacturer].inplace_edit = true
	config.columns[:manufacturer].form_ui = :select
  	config.columns[:manufacturer].options = {:include_blank => Russian.t('empty')}
	
	config.columns[:country].inplace_edit = :ajax
  config.columns[:country].form_ui = :select
	config.columns[:country].options = {:include_blank => Russian.t('empty')}
  
	config.columns[:serial].inplace_edit = true
	
	config.search.columns = [:boxing_type, :medicine, :measure,  :manufacturer,  
        :country, :serial]
	config.search.live = true
config.show.link = false
config.update.link = false

	config.list.per_page = 15
#	config.columns[:letter].sort = true
	#config.columns[:boxing_type].sort_by :sql => 'boxing_types.name'
	
  config.columns[:measure].search_sql = 'measures.name'
  config.columns[:boxing_type].search_sql = 'boxing_types.name'
	config.columns[:manufacturer].search_sql = 'manufacturers.name'
  config.columns[:country].search_sql = 'countries.name'
  config.columns[:medicine].search_sql = 'medicines.name' 
  #config.columns[:serial].search_sql = 'serials.name' 
	
  config.columns[:detail_type].sort_by :sql => 'detail_types.letter_id'
	
	config.list.always_show_search = true
end 

  def create_authorized?
    return false unless current_user
    current_user.is_an_operator?
  end
  

  
  def delete_authorized?
    return false unless current_user
    current_user.is_an_operator?
  end 
  

  # GET /letter_details/1
  # GET /letter_details/1.xml
  def show
    @letter_detail = LetterDetail.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @letter_detail }
    end
  end

  
  def create
    if params['measure'] && !params['measure']['name'].blank?  
      @measure = Measure.find_by_name(params['measure']['name'])  
      @measure = Measure.create(:name => params['measure']['name'] ) if @measure.nil? 
    end  
    
    if params['medicine'] && !params['medicine']['name'].blank?  
      @medicine = Medicine.find_by_name(params['medicine']['name'])  
      @medicine  = Medicine.create(:name => params['medicine']['name'] ) if @medicine.nil? 
    end 
    
    if params['manufacturer'] && !params['manufacturer']['name'].blank?  
      @manufacturer = Manufacturer.find_by_name(params['manufacturer']['name'])  
      @manufacturer = Manufacturer.create(:name => params['manufacturer']['name'] ) if @manufacturer.nil? 
    end 
    if params['boxing_type'] && !params['boxing_type']['name'].blank?  
      @boxing_type = BoxingType.find_by_name(params['boxing_type']['name'])  
      @boxing_type = BoxingType.create(:name => params['boxing_type']['name'] ) if @boxing_type.nil? 
    end 
    if params['detail_type'] && !params['detail_type']['name'].blank?  
      @detail = DetailType.find_by_name(params['detail_type']['name'])  
      @detail = DetailType.create(:name => params['detail_type']['name'] ) if @detail.nil? 
    end 
    if params['country'] && !params['country']['name'].blank?  
      @country = Country.find_by_name(params['country']['name'])  
      @country = Country.create(:name => params['country']['name'] ) if @country.nil? 
    end 
    super  
  end
  
private  
  def before_create_save(record)  
    record.measure_id = @measure.id if @measure
    record.medicine_id = @medicine.id if @medicine
    record.boxing_type_id = @boxing_type.id if @boxing_type
    record.manufacturer_id = @manufacturer.id if @manufacturer
     record.country_id = @country.id if @country
     record.detail_type_id = @detail_type.id if @detail_type
  end  
public
  # GET /letter_details/new
  # GET /letter_details/new.xml
 
=begin
 def new
    @letter_detail = LetterDetail.new
  if params[:id]
  @letter = Letter.find(params[:id])
  @letter_detail.letter = @letter
  end

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @letter_detail }
    end
  end
=end
=begin
  # GET /letter_details/1/edit
  def edit
    @letter_detail = LetterDetail.find(params[:id])
  end

  # POST /letter_details
  # POST /letter_details.xml
  def create
    @letter_detail = LetterDetail.new(params[:letter_detail])
    puts "+++++++++++++++"
    puts params
    puts "----------"
    respond_to do |format|
      if @letter_detail.save
        format.html { redirect_to(@letter_detail, :notice => 'LetterDetail was successfully created.') }
        format.xml  { render :xml => @letter_detail, :status => :created, :location => @letter_detail }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @letter_detail.errors, :status => :unprocessable_entity }
      end
    end
  end


  # PUT /letter_details/1
  # PUT /letter_details/1.xml
  def update
    @letter_detail = LetterDetail.find(params[:id])

    respond_to do |format|
      if @letter_detail.update_attributes(params[:letter_detail])
        format.html { redirect_to(@letter_detail, :notice => 'LetterDetail was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @letter_detail.errors, :status => :unprocessable_entity }
      end
    end
  end
=end
  # DELETE /letter_details/1
  # DELETE /letter_details/1.xml
=begin
 def destroy
    @letter_detail = LetterDetail.find(params[:id])
    @letter_detail.destroy

    respond_to do |format|
      format.html { redirect_to(letter_details_url) }
      format.xml  { head :ok }
    end
  end
=end
end

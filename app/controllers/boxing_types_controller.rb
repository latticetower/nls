class BoxingTypesController < ApplicationController
active_scaffold :boxing_type do |config|
    config.label = Russian.t(:boxing_type)
    config.columns = [:name]
    config.list.columns = [:name]
	
	##todo: use this 
	config.columns.each do |column|
	  column.label = Russian.t(column.name)
	end
	
	config.list.sorting = {:name => 'ASC'}
	
	config.search.columns = [:name]
	config.search.live = true
	
	config.list.per_page = 15
	config.columns[:name].sort = true
	config.columns[:name].sort_by :sql => 'boxing_types.name'
	
	config.list.always_show_search = true

end 


  # GET /boxing_types/1
  # GET /boxing_types/1.xml
  def show
    @boxing_type = BoxingType.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @boxing_type }
    end
  end

  # GET /boxing_types/new
  # GET /boxing_types/new.xml
  def new
    @boxing_type = BoxingType.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @boxing_type }
    end
  end

  # GET /boxing_types/1/edit
  def edit
    @boxing_type = BoxingType.find(params[:id])
  end

  # POST /boxing_types
  # POST /boxing_types.xml
  def create
    @boxing_type = BoxingType.new(params[:boxing_type])

    respond_to do |format|
      if @boxing_type.save
        format.html { redirect_to(boxing_types_url) }
        format.xml  { render :xml => @boxing_type, :status => :created, :location => @boxing_type }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @boxing_type.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /boxing_types/1
  # PUT /boxing_types/1.xml
  def update
    @boxing_type = BoxingType.find(params[:id])

    respond_to do |format|
      if @boxing_type.update_attributes(params[:boxing_type])
        format.html { redirect_to(boxing_types_url) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @boxing_type.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /boxing_types/1
  # DELETE /boxing_types/1.xml
  def destroy
    @boxing_type = BoxingType.find(params[:id])
    @boxing_type.destroy

    respond_to do |format|
      format.html { redirect_to(boxing_types_url) }
      format.xml  { head :ok }
    end
  end
end

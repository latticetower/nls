class MeasuresController < ApplicationController

  active_scaffold :measure do |config|
      config.label = Russian.t(:measures)
      config.columns = [:name]
      config.list.columns = [:name]
    
    ##todo: use this 
    config.columns.each do |column|
       column.label = Russian.t(column.name)
    end
    config.actions.exclude :show
    config.list.sorting = {:name => 'ASC'}
    
    config.search.columns = [:name]
    config.search.live = true
    
    config.list.per_page = 15
    config.columns[:name].sort = true
    config.columns[:name].sort_by :sql => 'measures.name'
    
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
  # GET /measures/1
  # GET /measures/1.xml
  def show
    @measure = Measure.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @measure }
    end
  end

  # GET /measures/new
  # GET /measures/new.xml
  def new
    @measure = Measure.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @measure }
    end
  end

  # GET /measures/1/edit
  def edit
    @measure = Measure.find(params[:id])
  end

  # POST /measures
  # POST /measures.xml
  def create
    @measure = Measure.new(params[:measure])

    respond_to do |format|
      if @measure.save
        format.html { redirect_to(measures_url) }
        format.xml  { render :xml => @measure, :status => :created, :location => @measure }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @measure.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /measures/1
  # PUT /measures/1.xml
  def update
    @measure = Measure.find(params[:id])

    respond_to do |format|
      if @measure.update_attributes(params[:measure])
        format.html { redirect_to(measures_url) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @measure.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /measures/1
  # DELETE /measures/1.xml
  def destroy
    @measure = Measure.find(params[:id])
    @measure.destroy

    respond_to do |format|
      format.html { redirect_to(measures_url) }
      format.xml  { head :ok }
    end
  end
end

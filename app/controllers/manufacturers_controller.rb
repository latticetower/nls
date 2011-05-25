class ManufacturersController < ApplicationController
  active_scaffold :manufacturer do |config|
    config.label = Russian.t(:manufacturers)
    config.columns = [:name]
    config.list.columns = [:name]
		config.columns.each do |column|
	   column.label = Russian.t(column.name)
	end
  config.actions.exclude :show
	config.list.sorting = {:name => 'ASC'}
	
	config.search.columns = [:name]
	config.search.live = true
	
	config.list.per_page = 15
	config.columns[:name].sort = true
	config.columns[:name].sort_by :sql => 'manufacturers.name'
	
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
  

  # GET /manufacturers/new
  # GET /manufacturers/new.xml
  def new
    @manufacturer = Manufacturer.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @manufacturer }
    end
  end

  # GET /manufacturers/1/edit
  def edit
    @manufacturer = Manufacturer.find(params[:id])
  end

  # POST /manufacturers
  # POST /manufacturers.xml
  def create
    @manufacturer = Manufacturer.new(params[:manufacturer])

    respond_to do |format|
      if @manufacturer.save
        format.html { redirect_to(manufacturers_url)  }
        format.xml  { render :xml => @manufacturer, :status => :created, :location => @manufacturer }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @manufacturer.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /manufacturers/1
  # PUT /manufacturers/1.xml
  def update
    @manufacturer = Manufacturer.find(params[:id])

    respond_to do |format|
      if @manufacturer.update_attributes(params[:manufacturer])
        format.html { redirect_to(manufacturers_url)  }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @manufacturer.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /manufacturers/1
  # DELETE /manufacturers/1.xml
  def destroy
    @manufacturer = Manufacturer.find(params[:id])
    @manufacturer.destroy

    respond_to do |format|
      format.html { redirect_to(manufacturers_url) }
      format.xml  { head :ok }
    end
  end
end

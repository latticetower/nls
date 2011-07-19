class CountriesController < ApplicationController
 
 active_scaffold :country do |config|
    config.label = Russian.t(:countries)
    config.list.columns = config.create.columns = config.update.columns = [:name] 
	config.columns.each do |column|
	  column.label = Russian.t(column.name)
	end
	config.list.sorting = {:name => 'ASC'}
	config.actions.exclude :show
	config.search.columns = [:name]
	config.search.live = true
	
	config.list.per_page = 15
	config.columns[:name].sort = true
	config.columns[:name].sort_by :sql => 'countries.name'
	
	config.list.always_show_search = true

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
  def list_authorized?
    return false unless current_user
   # current_user.is_an_operator_or_admin?
   true
  end
  # GET /countries/1
  # GET /countries/1.xml
  def show
    @country = Country.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @country }
    end
  end

  # GET /countries/new
  # GET /countries/new.xml
  def new
    @country = Country.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @country }
    end
  end

  # GET /countries/1/edit
  def edit
    @country = Country.find(params[:id])
  end

  # POST /countries
  # POST /countries.xml
  def create
    @country = Country.new(params[:country])

    respond_to do |format|
      if @country.save
        format.html { redirect_to(countries_url) }
        format.xml  { render :xml => @country, :status => :created, :location => @country }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @country.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /countries/1
  # PUT /countries/1.xml
  def update
    @country = Country.find(params[:id])

    respond_to do |format|
      if @country.update_attributes(params[:country])
        format.html { redirect_to(countries_url) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @country.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /countries/1
  # DELETE /countries/1.xml
  def destroy
    @country = Country.find(params[:id])
    @country.destroy

    respond_to do |format|
      format.html { redirect_to(countries_url) }
      format.xml  { head :ok }
    end
  end
end

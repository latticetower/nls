class OrganizationsController < ApplicationController


  active_scaffold :organization do |config|
    config.label = Russian.t(:organizations)
    config.columns = [:name, :name_long]
    config.list.columns = [:name, :name_long]
	config.actions.exclude :show
    ##todo: use this 
    config.columns.each do |column|
       column.label = Russian.t(column.name)
    end
	
    config.list.sorting = {:name => 'ASC'}
    
    config.search.columns = [:name]
    config.search.live = true
    
    config.list.per_page = 15
    config.columns[:name].sort = true
    config.columns[:name].sort_by :sql => 'organizations.name'
    
    config.list.always_show_search = true
  end 
  
  def create_authorized?
    return false unless current_user
    current_user.is_an_admin_or_operator?
  end
  
  def update_authorized?
    return false unless current_user
    current_user.is_an_admin_or_operator?
  end
  
  def delete_authorized?
    return false unless current_user
    current_user.is_an_admin_or_operator?
  end 
  def conditions_for_collection
    if current_user.is_a_client_or_manager?
      return ['id in (?)', current_user.organization_id]
    end
    []
  end

  # GET /organizations
  # GET /organizations.xml


  # GET /organizations/1
  # GET /organizations/1.xml
  def show
    @organization = Organization.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @organization }
    end
  end

  # GET /organizations/new
  # GET /organizations/new.xml
  def new
    @organization = Organization.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @organization }
    end
  end

  # GET /organizations/1/edit
  def edit
    @organization = Organization.find(params[:id])
  end

  # POST /organizations
  # POST /organizations.xml
  def create
    @organization = Organization.new(params[:organization])

    respond_to do |format|
      if @organization.save
        format.html { redirect_to(organizations_url, :notice => Russian.t(:organization) + Russian.t(:was_created_success)) }
        format.xml  { render :xml => @organization, :status => :created, :location => @organization }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @organization.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /organizations/1
  # PUT /organizations/1.xml
  def update
    @organization = Organization.find(params[:id])

    respond_to do |format|
      if @organization.update_attributes(params[:organization])
        format.html { redirect_to(organizations_url, :notice => Russian.t(:organization) + ' ' + Russian.t(:was_updated_success)) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @organization.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /organizations/1
  # DELETE /organizations/1.xml
  def destroy
    @organization = Organization.find(params[:id])
    @organization.destroy

    respond_to do |format|
      format.html { redirect_to(organizations_url) }
      format.xml  { head :ok }
    end
  end
end

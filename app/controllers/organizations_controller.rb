class OrganizationsController < ApplicationController
before_filter :authorize
active_scaffold :organizations

#record_select :per_page => 5, :search_on =>'name' #, :label => 'user_description'
  # GET /organizations
  # GET /organizations.xml
  def index
  if not current_user.can_view_firms?
    # redirect_to :controller => "tickets", :action => "index" and return
	 @organizations = Organization.find(:all, :conditions => {:id => current_user.organization_id})
  else
    @organizations = Organization.find(:all, :order => "name ASC")
end	
    respond_to do |format|
      format.html {render  :template => "organizations/index", :locals => { :current_user => current_user}}
      format.xml  { render :xml => @organizations }
    end
  end

  # GET /organizations/1
  # GET /organizations/1.xml
  def show
   redirect_to :action => :index
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
	    User.cin_users.each do |u|
		  u.showed_organizations << @organization
		  u.showed_organizations.save
		end
        flash[:notice] = 'Organization was successfully created.'
        format.html { redirect_to(@organization) }
        format.xml  { render :xml => @organization, :status => :created, :location => @organization }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @organization.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def create_ajax
      @organization = Organization.new(params[:organization])
	  
	  if @organization.save
	  User.cin_users.each do |u|
	  u.showed_organizations << @organization
	  end
		#  u.showed_organizations.save
         render :partial => 'organization_ajax', :object => @organization
      end
  end

  # PUT /organizations/1
  # PUT /organizations/1.xml
  def update
    @organization = Organization.find(params[:id])
	#params[:organization][:category_ids] = params[:organization][:category_ids].delete_if{|x| x[:id].nil? }
	#@organization.categories.each{|c| c.update_attributes(params[:organization][:category_ids][c.id.to_s]) }
    respond_to do |format|
      if @organization.update_attributes(params[:organization])
	  @organization.organization_categories.each  do |c|
	
	 
	     h = 0
	     h = params[:organization_categories][c.category_id.to_s][:hours] if params[:organization_categories][c.category_id.to_s]
	     c.hours = h.to_f
	     c.save
	  end
	  puts @organization.organization_categories.to_s
        flash[:notice] = 'Organization was successfully updated.'
        format.html { redirect_to(@organization) }
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

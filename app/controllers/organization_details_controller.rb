class OrganizationDetailsController < ApplicationController
  # GET /organization_details
  # GET /organization_details.xml
  def index
    @organization_details = OrganizationDetail.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @organization_details }
    end
  end

  # GET /organization_details/1
  # GET /organization_details/1.xml
  def show
    @organization_detail = OrganizationDetail.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @organization_detail }
    end
  end

  # GET /organization_details/new
  # GET /organization_details/new.xml
  def new
    @organization_detail = OrganizationDetail.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @organization_detail }
    end
  end

  # GET /organization_details/1/edit
  def edit
    @organization_detail = OrganizationDetail.find(params[:id])
  end

  # POST /organization_details
  # POST /organization_details.xml
  def create
    @organization_detail = OrganizationDetail.new(params[:organization_detail])

    respond_to do |format|
      if @organization_detail.save
        format.html { redirect_to(@organization_detail, :notice => 'OrganizationDetail was successfully created.') }
        format.xml  { render :xml => @organization_detail, :status => :created, :location => @organization_detail }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @organization_detail.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /organization_details/1
  # PUT /organization_details/1.xml
  def update
    @organization_detail = OrganizationDetail.find(params[:id])

    respond_to do |format|
      if @organization_detail.update_attributes(params[:organization_detail])
        format.html { redirect_to(@organization_detail, :notice => 'OrganizationDetail was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @organization_detail.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /organization_details/1
  # DELETE /organization_details/1.xml
  def destroy
    @organization_detail = OrganizationDetail.find(params[:id])
    @organization_detail.destroy

    respond_to do |format|
      format.html { redirect_to(organization_details_url) }
      format.xml  { head :ok }
    end
  end
end

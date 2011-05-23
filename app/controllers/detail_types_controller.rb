class DetailTypesController < ApplicationController
active_scaffold :detail_type do |config|
  config.label = Russian.t(:detail_types)
    config.columns = [ :name, :name_long]
    config.list.columns = [:name, :name_long]
	config.columns.each do |column|
	   column.label = Russian.t(column.name)
	end
end
def authorized?
  return false if not current_user
  current_user.is_an_admin_or_operator?
end
def authorized_for_create?
  return false if not current_user
  current_user.is_an_admin_or_operator?
end
def authorized_for_delete?
  return false if not current_user
  current_user.is_an_admin_or_operator?
end
def authorized_for_read?
  return false if not current_user
  current_user.is_an_admin_or_operator?
end
def authorized_for_update?
  return false if not current_user
  current_user.is_an_admin_or_operator?
end
 def conditions_for_collection
   if current_user.is_an_admin_or_operator?
    return []
   else 
   return ['1!=1']
   end
	 #return ['users.organization_id in (?)', current_user.showed_organizations]#, ['ticket_categories.category_id in (?)', current_user.categories]
	#else 
	# return ['users.id in (?)', current_user.id]
   # end
end

  # GET /detail_types/1
  # GET /detail_types/1.xml
  def show
    @detail_type = DetailType.find(params[:id])

    respond_to do |format|
      format.html { redirect_to(detail_types_url) }
      format.xml  { render :xml => @detail_type }
    end
  end

  # GET /detail_types/new
  # GET /detail_types/new.xml
  def new
    @detailtype = DetailType.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @detail_type }
    end
  end

  # GET /detail_types/1/edit
  def edit
    @detail_type = DetailType.find(params[:id])
  end

  # POST /detail_types
  # POST /detail_types.xml
  def create
    @detail_type = DetailType.new(params[:detail_type])

    respond_to do |format|
      if @detail_type.save
        format.html { redirect_to(@detail_type, :notice => 'DetailType was successfully created.') }
        format.xml  { render :xml => @detail_type, :status => :created, :location => @detail_type }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @detail_type.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /detail_types/1
  # PUT /detail_types/1.xml
  def update
    @detail_type = DetailType.find(params[:id])

    respond_to do |format|
      if @detail_type.update_attributes(params[:detail_type])
        format.html { redirect_to(@detail_type, :notice => 'DetailType was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @detail_type.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /detail_types/1
  # DELETE /detail_types/1.xml
  def destroy
    @detail_type = DetailType.find(params[:id])
    @detail_type.destroy

    respond_to do |format|
      format.html { redirect_to(detail_types_url) }
      format.xml  { head :ok }
    end
  end
end

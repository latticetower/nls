class UsersController < ApplicationController
##before_filter :authorize
  
#record_select :per_page => 5, :search_on =>'fio' #, :label => 'user_description'

active_scaffold :user do |config|
    config.label = Russian.t(:users)
    config.columns = [:role, :organization, :fio, :job, :room, :login]
    config.list.columns = [:role, :organization, :fio, :job, :room, :login]
	config.columns.each do |column|
	   column.label = Russian.t(column.name)
	end
	
	config.columns[:role].search_sql = 'roles.name'
	config.columns[:organization].search_sql = 'organizations.name'
	config.search.columns = [:role, :fio, :organization, :room, :login, :room]
	config.search.live = true
	
	config.columns[:fio].sort = true
	config.columns[:fio].sort_by :sql => 'fio'
	config.columns[:role].sort = true
	config.columns[:role].sort_by :sql => 'roles.name'
	config.columns[:organization].sort_by :sql => 'organizations.name'
	config.columns[:organization].clear_link 
	#there must be condition to show link for authorized admins
	config.list.sorting = {:organization => 'ASC', :role => 'ASC', :fio => 'ASC'}
	config.list.always_show_search = true
	#config.actions.add :list_filter 
#	config.list_filter.add(:date, :created_at, {:label => "fio"})
	#config.field_search.columns = [:created_at, :problem, :organization]
end

def authorized_for_read?
return false unless current_user
  current_user.is_a_tehnik_or_admin?
end

def authorized_for_delete?
  return false unless current_user
  current_user.is_an_admin?
end

def conditions_for_collection
 #   if current_user.can_manage_users? 
	 return ['users.organization_id in (1)']##, current_user.showed_organizations]#, ['ticket_categories.category_id in (?)', current_user.categories]
	#else 
	## return ['users.id in (?)', current_user.id]
    #end
end

  # GET /users
  # GET /users.xml
 #def index
 # @users = User.find(:all, :order => "organization_id ASC, fio ASC")
 #  puts "session__________ = " + session[:user_id].to_s()

#    respond_to do |format|
#      format.html { render :template => "users/index", :locals => {:current_user => current_user} }
#      format.xml  { render :xml => @users.to_xml(:dasherize => false, :skip_types => true, :skip_instruct => true, :except => [:password, :last_sync] ) }
#    end
#  end

  # GET /users/1
  # GET /users/1.xml
  def show
    redirect_to :action => :index
  end

  # GET /users/new
  # GET /users/new.xml
  def new
    @user = User.new
	@organizations = Organization.all
	@roles = Role.all
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @user }
    end
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
  end

  def edit_details
  @user = current_user
  end
  
  # POST /users
  # POST /users.xml
  def create
    @user = User.new(params[:user])
	@user.last_sync = Time.now
    respond_to do |format|
      if @user.save
        flash[:notice] = 'User was successfully created.'
        format.html { redirect_to :action => :index }
        format.xml  { render :xml => @user, :status => :created, :location => @user }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end
  
   def create_ajax
      @user = User.new(params[:user])
	  @user.last_sync = Time.now
	  @current_user = current_user
	  if @user.save
         render :partial => 'user_ajax', :object => @user and return
      end
	  render :text => ''
   end

  # PUT /users/1
  # PUT /users/1.xml
  def update
    @user = User.find(params[:id])
	
    respond_to do |format|
      if @user.update_attributes(params[:user])
        flash[:notice] = 'User was successfully updated.'
        format.html { redirect_to(@user) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def update_current
    @user = current_user

    respond_to do |format|
      if @user.update_attributes(params[:user])
        flash[:notice] = 'User was successfully updated.'
        format.html { redirect_to :controller => 'tickets', :action => 'index'}
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.xml
  def destroy
    @user = User.find(params[:id])
    @user.destroy

    respond_to do |format|
      format.html { redirect_to(users_url) }
      format.xml  { head :ok }
    end
  end
  
  def destroy_ajax
    @user = User.find(params[:id])
    @user.destroy
    @users = User.all

    render :partial => 'destroy_ajax', :object => @users, :locals => {:current_user => current_user}
  end

  
end

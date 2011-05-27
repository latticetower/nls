class UsersController < ApplicationController
  before_filter :authorize

  record_select :per_page => 5, :search_on => 'fio' #, :label => 'user_description'

  active_scaffold :user do |config|
      config.label = Russian.t(:users)
      config.columns = [#:registered_at,  
                        :role,  :email, :organization, :active]
      config.list.columns = [#:registered_at, 
                      :role, :email, :organization, :active]
      config.columns.each do |column|
        column.label = Russian.t(column.name)
      end
      config.create.columns = [:role, :email]
      config.columns[:role].search_sql = 'roles.name'
    	config.columns[:organization].search_sql = 'organizations.name'
      config.search.columns = [:role, :email]
      config.search.live = true
      config.columns[:role].clear_link 
      config.columns[:role].sort = true
      config.columns[:role].sort_by :sql => 'roles.name'
      config.columns[:role].inplace_edit = true
      config.columns[:role].form_ui = :select
    
      config.columns[:active].inplace_edit = true
      config.columns[:active].form_ui = :checkbox
    #	config.columns[:organization].sort_by :sql => 'organizations.name'
      config.columns[:organization].clear_link 
      config.columns[:email].inplace_edit = true
      config.columns[:organization].inplace_edit = true
      config.columns[:organization].form_ui = :select
      #there must be condition to show link for authorized admins
      config.list.sorting = { #:registered_at => 'DESC', 
      :id => 'DESC'}
      config.list.always_show_search = true
      config.columns[:registered_at].form_ui = :datepicker
      config.columns[:registered_at].search_ui = :date
      #config.actions.add :list_filter 
    #	config.list_filter.add(:date, :created_at, {:label => "fio"})
      #config.actions.swap :search, :field_search
      config.search.columns = [ :role, :email, :organization]
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
     if current_user.is_an_admin_or_operator?
      return []
     else 
     return ['users.id in(?)', current_user.id]
     end
     #return ['users.organization_id in (?)', current_user.showed_organizations]#, ['ticket_categories.category_id in (?)', current_user.categories]
    #else 
    # return ['users.id in (?)', current_user.id]
     # end
  end

def active_authorized?
  return true if current_user.is_an_admin_or_operator?
  return false
end
def role_authorized?
  return false if not current_user
  return true if current_user.is_an_admin_or_operator?
  return false
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
	 # @organizations = Organization.all
	#  @roles = Role.all
    respond_to do |format|
      format.html {redirect_to :controller => :login, :action => :register}# new.html.erb
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
    @user.update_attribute(:registered_at, Time.now)
    respond_to do |format|
      if @user.save
        flash[:notice] = 'User was successfully created.'
        format.html { redirect_to :action => :index }

      else
        format.html { render :action => "new" }
      end
    end
  end
  
   def create_ajax
      @user = User.new(params[:user])

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
        format.html { redirect_to :action => :index, :controller => :letters}
      else
        format.html { render :action => "edit" }
      end
    end
  end
  
  def update_current
    @user = current_user

    respond_to do |format|
      if @user.update_attributes(params[:user])
        flash[:notice] = 'User was successfully updated.'
        format.html { redirect_to :controller => 'letters', :action => 'index'}
      else
        format.html { render :action => "edit" }
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
    end
  end
  
  def destroy_ajax
    @user = User.find(params[:id])
    @user.destroy
    @users = User.all

    render :partial => 'destroy_ajax', :object => @users, :locals => {:current_user => current_user}
  end

  
end

class LettersController < ApplicationController
auto_complete_for :organization, :name  

active_scaffold :letters do |config|
    config.label = Russian.t(:letter)
    config.columns = [:item, :item_date, :organization]
    config.list.columns = [:item, :item_date, :organization]
	config.actions = [:create, :list, :search, :show, :update, :delete, :nested, :subform] 
	##todo: use this 
	config.columns.each do |column|
	   column.label = Russian.t(column.name)
	end
  config.nested.add_link(Russian.t('edit_letter'), [:letter_details])
	config.action_links.add 'reply', :label => 'Reply', :type => :record, :page => true
	#config.action_links.add 'edit_letter', :label => 'edit', :type => :record, :page => true
	config.action_links[:reply].label = Russian.t('reply')
	#config.action_links[:edit_letter].label = Russian.t('edit_letter')
	
	config.columns[:item].inplace_edit = true
	config.columns[:item_date].inplace_edit = true
	#config.columns[:organization].inplace_edit = true
	config.columns[:organization].form_ui = :select
    
	config.list.sorting = {:item => 'ASC'}
	config.search.columns = [:item, :created_on, :organization]
	config.search.live = true
	config.show.link = false
	
	config.list.per_page = 15
	config.columns[:item].sort = true
	config.columns[:item].sort_by :sql => 'item'
	config.columns[:created_on].search_ui = :date
	config.list.always_show_search = true

end 

def authorized_for_read?
  return false if not current_user
  return current_user.can_view_letters?
end
def authorized_for_update?
  return false if not current_user
  return current_user.is_a_operator?
end

def authorized_for_delete?
  return false unless current_user
  current_user.is_a_tehnik?
end

#для актив скаффолда
=begin
def conditions_for_collection
    if current_user.can_view_all_tickets? 
	 return ['tickets.organization_id in (?) and done=false', current_user.showed_organizations]#, ['ticket_categories.category_id in (?)', current_user.categories]
    end
    if current_user.can_view_firm_tickets?
     return ['tickets.organization_id in (?)  and done=false', current_user.organization_id] 
	end
    if current_user.can_view_ticket?
      return ['tickets.created_by in (?)  and done=false', current_user.id] 
    end  
end
=end
  # GET /letters/1
  # GET /letters/1.xml
  def show
    @letter = Letter.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @letter }
    end
  end
  def edit_letter
    @letter = Letter.find(params[:id])

	redirect_to :controller => :letters, :action => 'show', :id => @letter.id and return
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @letter }
    end
  end
  
   def reply
    @letter = Letter.find(params[:id])

	redirect_to :controller => :answers, :action => 'show', :id => @letter.id and return
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @letter }
    end
  end

    # GET /letters/1
  # GET /letters/1.xml
  def show_answer
    @letter = Letter.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @letter }
    end
  end
  # GET /letters/new
  # GET /letters/new.xml
  def new
    @letter = Letter.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @letter }
    end
  end

  # GET /letters/1/edit
  def edit
    @letter = Letter.find(params[:id])
  end

  # POST /letters
  # POST /letters.xml
  def create
  if params['organization'] && !params['organization']['name'].blank?  
      @organization = Organization.find_by_name(params['organization']['name'])  
    end  
    super  

  end
private  
  def before_create_save(record)  
    record.organization_id = @organization.id if @organization
  end  
public
  # PUT /letters/1
  # PUT /letters/1.xml
  def update
    @letter = Letter.find(params[:id])
    respond_to do |format|
      if @letter.update_attributes(params[:letter])
        format.html { redirect_to(@letter, :notice => 'Letter was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @letter.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /letters/1
  # DELETE /letters/1.xml
  def destroy
    @letter = Letter.find(params[:id])
    @letter.destroy

    respond_to do |format|
      format.html { redirect_to(letters_url) }
      format.xml  { head :ok }
    end
  end
end

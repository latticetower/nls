require 'data_file'

class LettersController < ApplicationController
  auto_complete_for :organization, :name  

  
  active_scaffold :letters do |config|
      config.label = Russian.t(:letters)
      config.create.label = Russian.t(:letter_create)
      config.update.label = Russian.t(:letter_update)
      config.nested.label = Russian.t(:letter_nested)
      config.show.label = ''
      config.columns = [:item, :item_date, :organization, 
        :letter_state, :line_count, :answered]
      config.list.columns = [:created_on, :item, :item_date, :organization, 
        :letter_state, :line_count, :answered]
      config.update.columns.exclude :line_count
       config.create.columns.exclude :line_count
       config.show.columns.exclude :line_count
       config.create.columns.exclude :answered
       config.update.columns.exclude :answered
    config.actions = [:create, :list,  :search, :show, :update, :delete, :nested, :subform] 
    ##todo: use this  
    config.list.mark_records = true
    config.columns.each do |column|
       column.label = Russian.t(column.name)
    end
   
    
    config.nested.add_link(Russian.t('edit_letter'), :letter_details, :label => Russian.t('edit_letter'))
    config.show.label = ''
    config.action_links.add 'reply', :label => 'Reply', :type => :member, :page => true
    #TODO: show some answers to inspector on demand
   ## config.nested.add_link(Russian.t('show_answers'), :answer_details, :label => Russian.t('show_letter'))
    #record
    config.action_links.add 'edit_letter', :label => 'edit', :type => :record, :page => true
    config.action_links[:reply].label = Russian.t('reply')
  #	config.action_links[:edit_letter].label = Russian.t('edit_letter')
    config.action_links.add 'unmark', :label => Russian.t('unmark'), 
      :type => :member, :inline => true, :position => :replace, :page => false
    
    config.action_links.add 'print_marked', :label => Russian.t(:print_marked),
    :type => :collection, :popup => true
    #config.action_links.add 'print_controler', :label => 'Print for controler', :type => :collection, :popup => true
    
     config.action_links.add 'print_for_tu', :label => Russian.t(:print_for_tu),
    :type => :collection, :popup => true
    config.action_links.add 'print_for_tu2', :label => Russian.t(:print_for_tu2),
    :type => :collection, :popup => true
    
    config.columns[:item].inplace_edit = true
    config.columns[:item_date].inplace_edit = true
    config.columns[:organization].inplace_edit = true
    
    config.columns[:organization].form_ui = :select
    config.columns[:letter_state].inplace_edit = true
    config.columns[:letter_state].form_ui = :select
      
    config.list.sorting = {:item => 'ASC'}
    config.search.columns = [:item, :created_on, :organization]
    config.search.live = true
    config.show.link = false
    
    config.list.per_page = 15
    config.columns[:item].sort = true
    config.columns[:item].sort_by :sql => 'item'
    
    config.columns[:created_on].search_ui = :date
    config.columns[:organization].search_sql = 'organizations.name'
    config.list.always_show_search = true
    config.list.sorting = {:created_on => 'DESC'}
    #config.field_search.columns = :created_on, :item, :item_date
  end 
  def unmark
    record = Letter.find(params[:id])
    render :nothing => true and return unless record
    record.set_answered(false)
    render :nothing => true
    #render :partial => "list_record", :object => record
    #_list_record.html.erb
  end
  
  #TODO: print marked must print all marked letters data as a rtf report
  def print_marked
    @letters = Letter.find(:all, :conditions => {:id => marked_records.to_a})
    render :xml => @letters.to_xml
      mime_type = "application/msword"
    @user = current_user
    @file = DataFile.do_rtf(@user, @letters)
      # Send the new file with the wordprocessingml document
      # content type.
    send_file(@file, :filename => Russian.t(:letters) + " - " + Time.now.to_s + ".doc", :type => mime_type)
    @letters.each do |letter|
    
      @answer = letter.make_answer
      if not @answer.answered
        @answer.update_attribute(:answered, true) 
      end
      #@answer.update_attribute(:answer_date, Time.now)
    end
    #marked_records.clear
  end
  def print_for_tu_authorized?
    return false if not current_user
    return false if not current_user.is_an_inspector?
    return current_user.allow_experimental
  end
  
  def print_for_tu2_authorized?
    return false if not current_user
    return false if not current_user.is_an_inspector?
    return current_user.allow_experimental
  end
  
  ##TODO: test controller, must be removed
  def print_for_tu_result
    @letters = Letter.find(:all, :conditions => ['item_date between ? and ?', 
                params[:report][:starts_at], 
                params[:report][:ends_at]])
    render :xml => @letters.to_xml
    @rt = params[:report][:report_type]
    @rg = params[:report][:report_group]
       @rgt = params[:report][:report_grouptype] if params[:report]   
      mime_type = "application/msword"
    @user = current_user
    @file = DataFile.do_rtf_for_tu(@user, @letters, @rt, @rg, @rgt)
      # Send the new file with the wordprocessingml document
      # content type.
    send_file(@file, :filename => Russian.t(:letters) + " - " + Time.now.to_s + ".doc", :type => mime_type)
  end
  
  def print_data
  
    redirect_to :action => print_for_tu, :report => @report and return if params[:commit] == "print_for_tu"
         
    redirect_to :action => print_medicines, :report => @report and return if params[:commit] == "print_medicines"
         
    redirect_to :action => print_organizations, :report => @report and return if params[:commit] == "print_organizations"
    
  end
  
  ##TODO: print data
  def print_for_tu
    @starts_at = 1.month.ago.beginning_of_month.to_date
      @ends_at = 1.month.ago.end_of_month.to_date
    @report = params[:report]
    @starts_at = params[:report][:starts_at] if params[:report] and params[:report][:starts_at]
      @ends_at = params[:report][:ends_at] if params[:report] and params[:report][:ends_at]
    ##TODO: remove 
    @letters = Letter.by_dates(@starts_at,  @ends_at) 
                
    @rt = params[:report][:report_type] if params[:report]
    @rg = params[:report][:report_group] if params[:report]         
    @rgt = params[:report][:report_grouptype] if params[:report]      
    ## @letters = Letter.find(:all, :conditions => {:id => marked_records.to_a})
    render :xml => @letters.to_xml
      mime_type = "application/msword"
    @user = current_user
    @file = DataFile.do_rtf_for_tu(@user, @starts_at, @ends_at, @rt, @rg, @rgt)
 
    send_file(@file, :filename => Russian.t(:letters) + " - " + Time.now.to_s + ".doc", :type => mime_type)
 

  end
  
  def print_for_tu2
    @letters = Letter.find(:all, :conditions => {:id => marked_records.to_a})
    render :xml => @letters.to_xml
      mime_type = "application/msword"
    @user = current_user
    @file = DataFile.do_rtf_for_tu2(@user, @letters)
      # Send the new file with the wordprocessingml document
      # content type.
    send_file(@file, :filename => Russian.t(:letters) + " - " + Time.now.to_s + ".doc", :type => mime_type)
    @letters.each do |letter|
    
      @answer = letter.make_answer
      if not @answer.answered
        @answer.update_attribute(:answered, true) 
      end
      #@answer.update_attribute(:answer_date, Time.now)
    end
    #marked_records.clear
  end

  def print_controler
    @letters = Letter.find(:all, :conditions => {:id => marked_records.to_a})
    render :xml => @letters.to_xml
      mime_type = "application/msword"
    @user = current_user
    @file = DataFile.do_rtf(@user, @letters)
      # Send the new file with the wordprocessingml document
      # content type.
    send_file(@file, :filename => Russian.t(:letters) + " - " + Time.now.to_s + ".doc", :type => mime_type)
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
  
  def reply_authorized?
    return false unless current_user
    return false if current_user.is_an_inspector?
    return true
  end
  def print_marked_authorized?
    return false unless current_user
    return true if current_user.is_a_client_or_manager?
    return false
  end
#not in use - to use must be moved to model class
def line_count_authorized?
  return true if current_user.is_an_admin_or_operator?
  return false
end
#��� ����� ���������

def conditions_for_collection
if current_user.is_a_client_or_manager_or_inspector?
return ['letters.state_id in (2)']
end
[]
=begin  
  if current_user.can_view_all_tickets? 
	 return ['tickets.organization_id in (?) and done=false', current_user.showed_organizations]#, ['ticket_categories.category_id in (?)', current_user.categories]
    end
    if current_user.can_view_firm_tickets?
     return ['tickets.organization_id in (?)  and done=false', current_user.organization_id] 
	end
    if current_user.can_view_ticket?
      return ['tickets.created_by in (?)  and done=false', current_user.id] 
    end  
=end
end

  # GET /letters/1
  # GET /letters/1.xml
=begin
  def show
    @letter = Letter.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @letter, :include => [ :letter_details ] }
    end
  end
=end  
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
=begin
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
=end
  # POST /letters
  # POST /letters.xml
  def create
   if params['organization'] && !params['organization']['name'].blank?  
      @organization = Organization.find_by_name(params['organization']['name'])  
      if @organization.nil? 
      @organization = Organization.create(:name => params['organization']['name'] )
      end
    end  
   if params['letter_state'] && !params['letter_state']['name'].blank?  
      @letter_state = LetterState.find_by_name(params['letter_state']['name'])  
    end 

    super  
  end
private  
  def before_create_save(record)  
    record.organization_id = @organization.id if @organization
    record.state_id = @letter_state.id if @letter_state
   # record.letter_detail.country_id = @country.id if @country
  end  
public
  # PUT /letters/1
  # PUT /letters/1.xml
=begin
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
=end
  # DELETE /letters/1
  # DELETE /letters/1.xml
  def destroy
  redirect_to(letters_url) and return if not current_user
    redirect_to(letters_url) and return if not current_user.is_an_operator_or_admin?
    @letter = Letter.find(params[:id])
    @letter.destroy

    respond_to do |format|
      format.html { redirect_to(letters_url) }
      format.xml  { head :ok }
    end
  end
  
  ##
  def print_organizations
    @starts_at = 1.month.ago.beginning_of_month.to_date
      @ends_at = 1.month.ago.end_of_month.to_date
    @report = params[:report]
    @starts_at = params[:report][:starts_at] if params[:report]
      @ends_at = params[:report][:ends_at] if params[:report]

    @rt = params[:report][:report_type] if params[:report]
    @rg = params[:report][:report_group] if params[:report]         
    @rgt = params[:report][:report_grouptype] if params[:report]      
    ## @letters = Letter.find(:all, :conditions => {:id => marked_records.to_a})
   
      mime_type = "application/msword"
    @user = current_user
    @file = DataFile.do_rtf_organizations(@user, @starts_at, @ends_at, @rt, @rg, @rgt)
 
    send_file(@file, :filename => Russian.t(:organizations) + " - " + Time.now.to_s + ".doc", :type => mime_type)
  end
  
  def print_medicines
    @starts_at = 1.month.ago.beginning_of_month.to_date
      @ends_at = 1.month.ago.end_of_month.to_date
       @report = params[:report]
    @starts_at = params[:report][:starts_at] if params[:report]
      @ends_at = params[:report][:ends_at] if params[:report]
    ##TODO: remove 
    
    @rt = params[:report][:report_type] if params[:report]
    @rg = params[:report][:report_group] if params[:report]         
    @rgt = params[:report][:report_grouptype] if params[:report]      
    ## @letters = Letter.find(:all, :conditions => {:id => marked_records.to_a})

      mime_type = "application/msword"
    @user = current_user
    @file = DataFile.do_rtf_medicines(@user, @starts_at, @ends_at, @rt, @rg, @rgt)
 
    send_file(@file, :filename => Russian.t(:medicines) + " - " + Time.now.to_s + ".doc", :type => mime_type)
  end
end

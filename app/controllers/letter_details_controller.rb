class LetterDetailsController < ApplicationController

active_scaffold :letter_details do |config|
    config.label = Russian.t(:letter_details)
    config.columns = [ :medicine, :boxing_type, :measure,  :manufacturer,  :country, :serial]
  	##todo: use this 
	config.columns.each do |column|
	   column.label = Russian.t(column.name)
	end
		
#	config.columns[:boxing_type].sort_by :sql => "boxing_type.name"
#	config.columns[:manufacturer].sort_by :sql => "manufacturer.name"
#	config.columns[:boxing_type].search_sql = "boxing_type.name"
#	config.columns[:manufacturer].search_sql = "manufacturer.name"
	config.list.sorting = {:letter => 'ASC'}
	
	config.columns[:medicine].inplace_edit = :ajax
	config.columns[:medicine].form_ui = :select
		
	config.columns[:boxing_type].inplace_edit = :ajax
	config.columns[:boxing_type].form_ui = :select
	
	config.columns[:measure].inplace_edit = true
	config.columns[:measure].form_ui = :select
	
	config.columns[:manufacturer].inplace_edit = true
	config.columns[:manufacturer].form_ui = :select
	
	config.columns[:country].inplace_edit = :ajax
		config.columns[:country].form_ui = :select
	config.columns[:country].options = {:include_blank => Russian.t('empty')}
	config.columns[:serial].inplace_edit = true
	
	config.search.columns = [:letter]
	config.search.live = true
config.show.link=false
config.update.link=false

	config.list.per_page = 15
	config.columns[:letter].sort = true
	config.columns[:letter].sort_by :sql => 'letter_details.letter_id'
	
	config.list.always_show_search = true
end 


def authorized_for_read?
  return true
 #return current_user.is_a_tehnik?
end

def authorized_for_delete?
  return true
 #current_user.is_a_tehnik?
end
  # GET /letter_details/1
  # GET /letter_details/1.xml
  def show
    @letter_detail = LetterDetail.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @letter_detail }
    end
  end

  # GET /letter_details/new
  # GET /letter_details/new.xml
  def new
    @letter_detail = LetterDetail.new
if params[:id]
@letter = Letter.find(params[:id])
@letter_detail.letter=@letter
end

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @letter_detail }
    end
  end
=begin
  # GET /letter_details/1/edit
  def edit
    @letter_detail = LetterDetail.find(params[:id])
  end
=end
  # POST /letter_details
  # POST /letter_details.xml
  def create
    @letter_detail = LetterDetail.new(params[:letter_detail])

    respond_to do |format|
      if @letter_detail.save
        format.html { redirect_to(@letter_detail, :notice => 'LetterDetail was successfully created.') }
        format.xml  { render :xml => @letter_detail, :status => :created, :location => @letter_detail }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @letter_detail.errors, :status => :unprocessable_entity }
      end
    end
  end
=begin
  # PUT /letter_details/1
  # PUT /letter_details/1.xml
  def update
    @letter_detail = LetterDetail.find(params[:id])

    respond_to do |format|
      if @letter_detail.update_attributes(params[:letter_detail])
        format.html { redirect_to(@letter_detail, :notice => 'LetterDetail was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @letter_detail.errors, :status => :unprocessable_entity }
      end
    end
  end
=end
  # DELETE /letter_details/1
  # DELETE /letter_details/1.xml
=begin
 def destroy
    @letter_detail = LetterDetail.find(params[:id])
    @letter_detail.destroy

    respond_to do |format|
      format.html { redirect_to(letter_details_url) }
      format.xml  { head :ok }
    end
  end
=end
end

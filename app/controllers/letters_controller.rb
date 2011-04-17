class LettersController < ApplicationController

active_scaffold :letters do |config|
    config.label = Russian.t(:letter)
    config.columns = [:item, :created_on]
    config.list.columns = [:item, :created_on]
	
	##todo: use this 
	#config.columns.each do |column|
	#   column.label = Russian.t(column.name)
	#end
	
	config.list.sorting = {:item => 'ASC'}
	
	config.search.columns = [:item]
	config.search.live = true
	
	config.list.per_page = 15
	config.columns[:item].sort = true
	config.columns[:item].sort_by :sql => 'letters.item'
	
	config.list.always_show_search = true

end 

  # GET /letters/1
  # GET /letters/1.xml
  def show
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
    @letter = Letter.new(params[:letter])

    respond_to do |format|
      if @letter.save
        format.html { redirect_to(@letter, :notice => 'Letter was successfully created.') }
        format.xml  { render :xml => @letter, :status => :created, :location => @letter }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @letter.errors, :status => :unprocessable_entity }
      end
    end
  end

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

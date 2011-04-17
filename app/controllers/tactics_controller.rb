class TacticsController < ApplicationController
active_scaffold :tactic do |config|
    config.label = Russian.t(:tactics)
    config.columns = [:name]
    config.list.columns = [:name]
	
	##todo: use this 
	#config.columns.each do |column|
	#   column.label = Russian.t(column.name)
	#end
	
	config.list.sorting = {:name => 'ASC'}
	
	config.search.columns = [:name]
	config.search.live = true
	
	config.list.per_page = 15
	config.columns[:name].sort = true
	config.columns[:name].sort_by :sql => 'tactics.name'
	
	config.list.always_show_search = true

end 

  # GET /tactics/1
  # GET /tactics/1.xml
  def show
    @tactic = Tactic.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @tactic }
    end
  end

  # GET /tactics/new
  # GET /tactics/new.xml
  def new
    @tactic = Tactic.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @tactic }
    end
  end

  # GET /tactics/1/edit
  def edit
    @tactic = Tactic.find(params[:id])
  end

  # POST /tactics
  # POST /tactics.xml
  def create
    @tactic = Tactic.new(params[:tactic])

    respond_to do |format|
      if @tactic.save
        format.html { redirect_to(@tactic, :notice => 'Tactic was successfully created.') }
        format.xml  { render :xml => @tactic, :status => :created, :location => @tactic }
      else
        format.html { render :tactic => "new" }
        format.xml  { render :xml => @tactic.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /tactics/1
  # PUT /tactics/1.xml
  def update
    @tactic = Tactic.find(params[:id])

    respond_to do |format|
      if @tactic.update_attributes(params[:tactic])
        format.html { redirect_to(@tactic, :notice => 'Action was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :tactic => "edit" }
        format.xml  { render :xml => @tactic.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /tactics/1
  # DELETE /tactics/1.xml
  def destroy
    @tactic = Action.find(params[:id])
    @tactic.destroy

    respond_to do |format|
      format.html { redirect_to(tactics_url) }
      format.xml  { head :ok }
    end
  end
end

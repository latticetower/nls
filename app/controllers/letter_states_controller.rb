class LetterStatesController < ApplicationController


active_scaffold :letter_states do |config|
    config.label = Russian.t(:letter_state)
    config.columns = [:name]
    config.list.columns = [:name]
	
	##todo: use this 
	config.columns.each do |column|
	   column.label = Russian.t(column.name)
	end
	config.actions.exclude :show
	config.list.sorting = {:name => 'ASC'}
	
	config.search.columns = [:name]
	config.search.live = true
	
	config.list.per_page = 15
	config.columns[:name].sort = true
	config.columns[:name].sort_by :sql => 'letter_states.name'
	
	config.list.always_show_search = true

end 
  def create_authorized?
    return false unless current_user
    current_user.is_an_admin?
  end
  
  def update_authorized?
    return false unless current_user
    current_user.is_an_admin?
  end
  
  def delete_authorized?
    return false unless current_user
    current_user.is_an_admin?
  end 
  # GET /letter_states/1
  # GET /letter_states/1.xml
  def show
    @letter_state = LetterState.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @letter_state }
    end
  end

  # GET /letter_states/new
  # GET /letter_states/new.xml
  def new
    @letter_state = LetterState.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @letter_state }
    end
  end

  # GET /letter_states/1/edit
  def edit
    @letter_state = LetterState.find(params[:id])
  end

  # POST /letter_states
  # POST /letter_states.xml
  def create
    @letter_state = LetterState.new(params[:letter_state])

    respond_to do |format|
      if @letter_state.save
        format.html { redirect_to(letter_states_url) }
        format.xml  { render :xml => @letter_state, :status => :created, :location => @letter_state }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @letter_state.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /letter_states/1
  # PUT /letter_states/1.xml
  def update
    @letter_state = LetterState.find(params[:id])

    respond_to do |format|
      if @letter_state.update_attributes(params[:letter_state])
        format.html { redirect_to(letter_states_url) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @letter_state.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /letter_states/1
  # DELETE /letter_states/1.xml
  def destroy
    @letter_state = LetterState.find(params[:id])
    @letter_state.destroy

    respond_to do |format|
      format.html { redirect_to(letter_states_url) }
      format.xml  { head :ok }
    end
  end
end

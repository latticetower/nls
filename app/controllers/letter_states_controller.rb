class LetterStatesController < ApplicationController
  # GET /letter_states
  # GET /letter_states.xml
  def index
    @letter_states = LetterState.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @letter_states }
    end
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
        format.html { redirect_to(@letter_state, :notice => 'LetterState was successfully created.') }
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
        format.html { redirect_to(@letter_state, :notice => 'LetterState was successfully updated.') }
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

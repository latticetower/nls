class AnswersController < ApplicationController
layout 'letters', :only => [:index, :show]
active_scaffold :answers do |config|
 config.nested.label = ''

end

  # GET /answers/1
  # GET /answers/1.xml
  def show
    @answer = Letter.find(params[:id])
@ld = @answer.letter_details
    for ld in @ld do
      if ld.find_answer_by_organization(current_user.organization_id) == nil
        ld.answer_details << AnswerDetail.new(:letter_id => @answer.id, :organization_id => current_user.organization_id)
      end
    end
    respond_to do |format|
      format.html # show.html.erb
      format.xml {render :xml => @answer }
    end
  end

  # GET /answers/new
  # GET /answers/new.xml
  def new
    @answer = Letter.new
    
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @answer }
    end
  end

  # GET /answers/1/edit
 # def edit
 #   @answer = Letter.find(params[:id])
 # end

  # POST /answers
  # POST /answers.xml
  def create
    @answer = Letter.new(params[:answer])

    respond_to do |format|
      if @answer.save
        format.html { redirect_to(@answer, :notice => 'Answer was successfully created.') }
        format.xml  { render :xml => @answer, :status => :created, :location => @answer }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @answer.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /answers/1
  # PUT /answers/1.xml
  def update
    @answer = Letter.find(params[:id])

    respond_to do |format|
      if @answer.update_attributes(params[:answer])
        format.html { redirect_to(@answer, :notice => 'Answer was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @answer.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /answers/1
  # DELETE /answers/1.xml
  def destroy
    @answer = Letter.find(params[:id])
    @answer.destroy

    respond_to do |format|
      format.html { redirect_to(answers_url) }
      format.xml  { head :ok }
    end
  end
end

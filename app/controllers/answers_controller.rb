class AnswersController < ApplicationController
  layout 'letters', :only => [:index, :show, :edit, :update_individual  ]
  

 
  active_scaffold :answers do |config|
     config.nested.label = ''
     config.actions = [:subform, :list, :show, :nested, :update, :create] 
     config.columns = [:letter]
  end
  
  def index 
    redirect_to :controller => :letters, :action => 'index'
  end
  # GET /answers/1
  # GET /answers/1.xml
  def show
  ##todo: must add condition
  @id = params[:id]
  @user_id = current_user.id
  
  @letter = Letter.find(@id)
    
 # @answer = Answer.find(:first, :conditions => {
  #      :letter_id => @id, 
  #      :user_id => @user_id
  #      })
  
    @answer = @letter.make_answer # if not @answer
    @ad = @answer.answer_details
 
    respond_to do |format|
      format.html # show.html.erb
      format.xml {render :xml => @answer }
    end
  end

  def create_ajax  
    ld = LetterDetail.find(params[:id])
    @ads = ld.answer_details.by_user(User.current_user.id)
    @ad = AnswerDetail.new(:user_id => current_user.id, :letter_detail_id => ld.id, 
    :supplier_name => params.to_s, :answer_id => self.id)
    
	 
	 #if @ad.save
         render :partial => 'create_ad_ajax', :locals => {:ad => @ad, :ld => ld}
    # end
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
  def edit
    @letter = Letter.find(params[:id])
    @answer = @letter.make_answer
  end

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
    @answer = self # if not @answer
    @ad = @answer.answer_details
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
  
  def update_individual  
    @ads = AnswerDetail.update(params[:answer_details].keys, 
      params[:answer_details].values).reject { |p| p.errors.empty? } 
 
    @ads_created = AnswerDetail.create(params[:unsaved_answer_details]).reject{|p| p.errors.empty?}
    #@ads_created.save
    #redirect_to answers_url   
    if @ads.empty?   
      flash[:notice] =  "Updated"
      redirect_to answers_url  
    else  
  
      @ad = @ads.first 
      @letter = @ad.letter
      @answer = @ad.answer
      redirect_to :action => 'edit', :id => @letter.id
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

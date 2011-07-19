class AnswersController < ApplicationController
  layout 'letters', :only => [:index, :show, :edit, :update_individual  ]
  
  
  auto_complete_for :answer_detail, :supplier_name
  
auto_complete_for :supplier, :name
  active_scaffold :answers do |config|
     config.nested.label = ''
     config.actions = [:subform, :list, :show, :nested, :update, :create] 
     config.columns = [:letter]
  end
  
=begin
  def auto_complete_for_answer_detail_supplier
    search = params[:answer_detail][:supplier]
    @suppliers = Supplier.search(search) unless search.blank?
    render :partial => "live/search"
  end
=end  
  def index 
    redirect_to :controller => :letters, :action => 'index'
  end
  # GET /answers/1
  # GET /answers/1.xml
  def show
  #redirect_to :action => 'edit', :id => params[:id] and return 
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

  #todo: метод переделать так, чтобы он принимал answer_id и letter_detail_id в виде массива
  def create_ajax  

    ld = LetterDetail.find(params[:letter_detail_id])
    #todo: fix this
    answer = Answer.find(params[:answer_id])

    @ad = AnswerDetail.new(:user_id => current_user.id, :letter_detail_id => ld.id, 
    :supplier_name => '', :answer_id => answer.id)
    
	 
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
    @ad = @answer.answer_details
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
    answer = Answer.find(params[:id])
    letter_id = answer.letter_id if answer
    @ads = AnswerDetail.update(params[:answer_details].keys, 
      params[:answer_details].values).reject { |p| p.errors.empty? } 
    if params[:unsaved_answer_details] 
      @ads_created = AnswerDetail.create(params[:unsaved_answer_details]).reject{|p| p.errors.empty?}
    end
    #@ads_created.save
    #redirect_to answers_url   
    if @ads.empty?   
      flash[:notice] =  "Updated"
      redirect_to answers_url  
    else  
      @ads.each do |ad|
        ad.errors.add("answer_detail", "ttt")
      end
      @ad = @ads.first 
      @letter = @ad.letter
      @answer = @ad.answer
      redirect_to :action => 'edit', :id => letter_id #туточки мы падаем если включить валидацию. строка 129
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

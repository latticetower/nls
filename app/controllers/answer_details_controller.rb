class AnswerDetailsController < ApplicationController
 layout 'streamlined'
    acts_as_streamlined
  # GET /answer_details
  # GET /answer_details.xml
  def index
    @answer_details = AnswerDetail.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @answer_details }
    end
  end

  # GET /answer_details/1
  # GET /answer_details/1.xml
  def show
    @answer_detail = AnswerDetail.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @answer_detail }
    end
  end

  # GET /answer_details/new
  # GET /answer_details/new.xml
  def new
    @answer_detail = AnswerDetail.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @answer_detail }
    end
  end

  # GET /answer_details/1/edit
  def edit
    @answer_detail = AnswerDetail.find(params[:id])
  end

  # POST /answer_details
  # POST /answer_details.xml
  def create
    @answer_detail = AnswerDetail.new(params[:answer_detail])

    respond_to do |format|
      if @answer_detail.save
        format.html { redirect_to(@answer_detail, :notice => 'AnswerDetail was successfully created.') }
        format.xml  { render :xml => @answer_detail, :status => :created, :location => @answer_detail }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @answer_detail.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /answer_details/1
  # PUT /answer_details/1.xml
  def update
    @answer_detail = AnswerDetail.find(params[:id])

    respond_to do |format|
      if @answer_detail.update_attributes(params[:answer_detail])
        format.html { redirect_to(@answer_detail, :notice => 'AnswerDetail was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @answer_detail.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /answer_details/1
  # DELETE /answer_details/1.xml
  def destroy
    @answer_detail = AnswerDetail.find(params[:id])
    @answer_detail.destroy

    respond_to do |format|
      format.html { redirect_to(answer_details_url) }
      format.xml  { head :ok }
    end
  end
end

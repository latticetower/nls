class LetterDetailsController < ApplicationController
  # GET /letter_details
  # GET /letter_details.xml
  def index
    @letter_details = LetterDetail.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @letter_details }
    end
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

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @letter_detail }
    end
  end

  # GET /letter_details/1/edit
  def edit
    @letter_detail = LetterDetail.find(params[:id])
  end

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

  # DELETE /letter_details/1
  # DELETE /letter_details/1.xml
  def destroy
    @letter_detail = LetterDetail.find(params[:id])
    @letter_detail.destroy

    respond_to do |format|
      format.html { redirect_to(letter_details_url) }
      format.xml  { head :ok }
    end
  end
end

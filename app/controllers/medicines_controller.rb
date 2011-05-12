class MedicinesController < ApplicationController
active_scaffold :medicine do |config|
    config.label = Russian.t(:medicines)
    config.columns = [:name]
    config.list.columns = [:name]
	
	##todo: use this 
	config.columns.each do |column|
	   column.label = Russian.t(column.name)
	end
	
	config.list.sorting = {:name => 'ASC'}
	
	config.search.columns = [:name]
	config.search.live = true
	
	config.list.per_page = 15
	config.columns[:name].sort = true
	config.columns[:name].sort_by :sql => 'medicines.name'
	
	config.list.always_show_search = true
end 


  # GET /medicines/1
  # GET /medicines/1.xml
  def show
    @medicine = Medicine.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @medicine }
    end
  end

  # GET /medicines/new
  # GET /medicines/new.xml
  def new
    @medicine = Medicine.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @medicine }
    end
  end

  # GET /medicines/1/edit
  def edit
    @medicine = Medicine.find(params[:id])
  end

  # POST /medicines
  # POST /medicines.xml
  def create
    @medicine = Medicine.new(params[:medicine])

    respond_to do |format|
      if @medicine.save
        format.html { 
        redirect_to(medicines_url)
        #redirect_to(@medicine, :notice => 'Medicine was successfully created.')
        }
        format.xml  { render :xml => @medicine, :status => :created, :location => @medicine }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @medicine.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /medicines/1
  # PUT /medicines/1.xml
  def update
    @medicine = Medicine.find(params[:id])

    respond_to do |format|
      if @medicine.update_attributes(params[:medicine])
        format.html {redirect_to(medicines_url)
        #redirect_to(@medicine, :notice => 'Medicine was successfully updated.')
        }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @medicine.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /medicines/1
  # DELETE /medicines/1.xml
  def destroy
    @medicine = Medicine.find(params[:id])
    @medicine.destroy

    respond_to do |format|
      format.html { redirect_to(medicines_url) }
      format.xml  { head :ok }
    end
  end
end

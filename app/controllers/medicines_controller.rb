class MedicinesController < ApplicationController
  # GET /medicines
  # GET /medicines.xml
  def index
    @medicines = Medicine.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @medicines }
    end
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
        format.html { redirect_to(@medicine, :notice => 'Medicine was successfully created.') }
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
        format.html { redirect_to(@medicine, :notice => 'Medicine was successfully updated.') }
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

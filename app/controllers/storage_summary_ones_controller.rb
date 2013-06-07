class StorageSummaryOnesController < ApplicationController
  # GET /storage_summary_ones
  # GET /storage_summary_ones.json
  def index
    @storage_summary_ones = StorageSummaryOne.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @storage_summary_ones }
    end
  end

  # GET /storage_summary_ones/1
  # GET /storage_summary_ones/1.json
  def show
    @storage_summary_one = StorageSummaryOne.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @storage_summary_one }
    end
  end

  # GET /storage_summary_ones/new
  # GET /storage_summary_ones/new.json
  def new
    @storage_summary_one = StorageSummaryOne.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @storage_summary_one }
    end
  end

  # GET /storage_summary_ones/1/edit
  def edit
    @storage_summary_one = StorageSummaryOne.find(params[:id])
  end

  # POST /storage_summary_ones
  # POST /storage_summary_ones.json
  def create
    @storage_summary_one = StorageSummaryOne.new(params[:storage_summary_one])

    respond_to do |format|
      if @storage_summary_one.save
        format.html { redirect_to @storage_summary_one, :notice => 'Storage summary one was successfully created.' }
        format.json { render :json => @storage_summary_one, :status => :created, :location => @storage_summary_one }
      else
        format.html { render :action => "new" }
        format.json { render :json => @storage_summary_one.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /storage_summary_ones/1
  # PUT /storage_summary_ones/1.json
  def update
    @storage_summary_one = StorageSummaryOne.find(params[:id])

    respond_to do |format|
      if @storage_summary_one.update_attributes(params[:storage_summary_one])
        format.html { redirect_to @storage_summary_one, :notice => 'Storage summary one was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @storage_summary_one.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /storage_summary_ones/1
  # DELETE /storage_summary_ones/1.json
  def destroy
    @storage_summary_one = StorageSummaryOne.find(params[:id])
    @storage_summary_one.destroy

    respond_to do |format|
      format.html { redirect_to storage_summary_ones_url }
      format.json { head :no_content }
    end
  end
end

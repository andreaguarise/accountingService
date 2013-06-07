class StorageSummaryTwosController < ApplicationController
  # GET /storage_summary_twos
  # GET /storage_summary_twos.json
  def index
    @storage_summary_twos = StorageSummaryTwo.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @storage_summary_twos }
    end
  end

  # GET /storage_summary_twos/1
  # GET /storage_summary_twos/1.json
  def show
    @storage_summary_two = StorageSummaryTwo.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @storage_summary_two }
    end
  end

  # GET /storage_summary_twos/new
  # GET /storage_summary_twos/new.json
  def new
    @storage_summary_two = StorageSummaryTwo.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @storage_summary_two }
    end
  end

  # GET /storage_summary_twos/1/edit
  def edit
    @storage_summary_two = StorageSummaryTwo.find(params[:id])
  end

  # POST /storage_summary_twos
  # POST /storage_summary_twos.json
  def create
    @storage_summary_two = StorageSummaryTwo.new(params[:storage_summary_two])

    respond_to do |format|
      if @storage_summary_two.save
        format.html { redirect_to @storage_summary_two, :notice => 'Storage summary two was successfully created.' }
        format.json { render :json => @storage_summary_two, :status => :created, :location => @storage_summary_two }
      else
        format.html { render :action => "new" }
        format.json { render :json => @storage_summary_two.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /storage_summary_twos/1
  # PUT /storage_summary_twos/1.json
  def update
    @storage_summary_two = StorageSummaryTwo.find(params[:id])

    respond_to do |format|
      if @storage_summary_two.update_attributes(params[:storage_summary_two])
        format.html { redirect_to @storage_summary_two, :notice => 'Storage summary two was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @storage_summary_two.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /storage_summary_twos/1
  # DELETE /storage_summary_twos/1.json
  def destroy
    @storage_summary_two = StorageSummaryTwo.find(params[:id])
    @storage_summary_two.destroy

    respond_to do |format|
      format.html { redirect_to storage_summary_twos_url }
      format.json { head :no_content }
    end
  end
end

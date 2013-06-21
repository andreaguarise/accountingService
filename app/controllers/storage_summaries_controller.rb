class StorageSummariesController < ApplicationController
  skip_before_filter :userAuthenticate
  # GET /storage_summaries
  # GET /storage_summaries.json
  def index
    @storage_summaries = StorageSummary.paginate( :page=>params[:page], :per_page => config.itemsPerPageHTML).orderByParms('id desc',params).all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @storage_summaries }
    end
  end

  # GET /storage_summaries/1
  # GET /storage_summaries/1.json
  def show
    @storage_summary = StorageSummary.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @storage_summary }
    end
  end

  # GET /storage_summaries/new
  # GET /storage_summaries/new.json
  def new
    @storage_summary = StorageSummary.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @storage_summary }
    end
  end

  # GET /storage_summaries/1/edit
  def edit
    @storage_summary = StorageSummary.find(params[:id])
  end

  # POST /storage_summaries
  # POST /storage_summaries.json
  def create
    @storage_summary = StorageSummary.new(params[:storage_summary])

    respond_to do |format|
      if @storage_summary.save
        format.html { redirect_to @storage_summary, :notice => 'Storage summary was successfully created.' }
        format.json { render :json => @storage_summary, :status => :created, :location => @storage_summary }
      else
        format.html { render :action => "new" }
        format.json { render :json => @storage_summary.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /storage_summaries/1
  # PUT /storage_summaries/1.json
  def update
    @storage_summary = StorageSummary.find(params[:id])

    respond_to do |format|
      if @storage_summary.update_attributes(params[:storage_summary])
        format.html { redirect_to @storage_summary, :notice => 'Storage summary was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @storage_summary.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /storage_summaries/1
  # DELETE /storage_summaries/1.json
  def destroy
    @storage_summary = StorageSummary.find(params[:id])
    @storage_summary.destroy

    respond_to do |format|
      format.html { redirect_to storage_summaries_url }
      format.json { head :no_content }
    end
  end
end

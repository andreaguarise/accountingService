class CloudRecordSummariesController < ApplicationController
  skip_before_filter :userAuthenticate
  # GET /cloud_record_summaries
  # GET /cloud_record_summaries.json
  def index
    respond_to do |format|
      format.html {
        @cloud_record_summaries = CloudRecordSummary.paginate(:page=>params[:page], :per_page => config.itemsPerPageHTML).all
      }
      format.any(:xml,:json){
        @cloud_record_summaries = CloudRecordSummary.paginate(:page=>params[:page], :per_page => config.itemsPerPage).all
      }
    end
    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @cloud_record_summaries }
      format.xml { render :xml => @cloud_record_summaries }
    end
  end

  # GET /cloud_record_summaries/1
  # GET /cloud_record_summaries/1.json
  def show
    @cloud_record_summary = CloudRecordSummary.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @cloud_record_summary }
    end
  end

  # GET /cloud_record_summaries/search?VMUUID=string
  def search
    respond_to do |format|
      format.html {
        @cloud_record_summaries = CloudRecordSummary.paginate(:page=>params[:page], :per_page => config.itemsPerPageHTML).all
      }
      format.any(:xml,:json){
        @cloud_record_summaries = CloudRecordSummary.paginate(:page=>params[:page], :per_page => config.itemsPerPage).all
      }
    end
    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @cloud_record_summaries }
      format.xml { render :xml => @cloud_record_summaries }
    end
  end


  # GET /cloud_record_summaries/new
  # GET /cloud_record_summaries/new.json
  def new
    @cloud_record_summary = CloudRecordSummary.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @cloud_record_summary }
    end
  end
 

  # GET /cloud_record_summaries/1/edit
  def edit
    @cloud_record_summary = CloudRecordSummary.find(params[:id])
  end

  # POST /cloud_record_summaries
  # POST /cloud_record_summaries.json
  def create
    @cloud_record_summary = CloudRecordSummary.new(params[:cloud_record_summary])

    respond_to do |format|
      if @cloud_record_summary.save
        format.html { redirect_to @cloud_record_summary, :notice => 'Cloud record summary was successfully created.' }
        format.json { render :json => @cloud_record_summary, :status => :created, :location => @cloud_record_summary }
      else
        format.html { render :action => "new" }
        format.json { render :json => @cloud_record_summary.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /cloud_record_summaries/1
  # PUT /cloud_record_summaries/1.json
  def update
    @cloud_record_summary = CloudRecordSummary.find(params[:id])

    respond_to do |format|
      if @cloud_record_summary.update_attributes(params[:cloud_record_summary])
        format.html { redirect_to @cloud_record_summary, :notice => 'Cloud record summary was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @cloud_record_summary.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /cloud_record_summaries/1
  # DELETE /cloud_record_summaries/1.json
  def destroy
    @cloud_record_summary = CloudRecordSummary.find(params[:id])
    @cloud_record_summary.destroy

    respond_to do |format|
      format.html { redirect_to cloud_record_summaries_url }
      format.json { head :no_content }
    end
  end
end

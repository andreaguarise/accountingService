class DatabaseRecordSummariesController < ApplicationController
  # GET /database_record_summaries
  # GET /database_record_summaries.json
  def index
    @database_record_summaries = DatabaseRecordSummary.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @database_record_summaries }
    end
  end

  # GET /database_record_summaries/1
  # GET /database_record_summaries/1.json
  def show
    @database_record_summary = DatabaseRecordSummary.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @database_record_summary }
    end
  end

  # GET /database_record_summaries/new
  # GET /database_record_summaries/new.json
  def new
    @database_record_summary = DatabaseRecordSummary.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @database_record_summary }
    end
  end

  # GET /database_record_summaries/1/edit
  def edit
    @database_record_summary = DatabaseRecordSummary.find(params[:id])
  end

  # POST /database_record_summaries
  # POST /database_record_summaries.json
  def create
    @database_record_summary = DatabaseRecordSummary.new(params[:database_record_summary])

    respond_to do |format|
      if @database_record_summary.save
        format.html { redirect_to @database_record_summary, :notice => 'Database record summary was successfully created.' }
        format.json { render :json => @database_record_summary, :status => :created, :location => @database_record_summary }
      else
        format.html { render :action => "new" }
        format.json { render :json => @database_record_summary.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /database_record_summaries/1
  # PUT /database_record_summaries/1.json
  def update
    @database_record_summary = DatabaseRecordSummary.find(params[:id])

    respond_to do |format|
      if @database_record_summary.update_attributes(params[:database_record_summary])
        format.html { redirect_to @database_record_summary, :notice => 'Database record summary was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @database_record_summary.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /database_record_summaries/1
  # DELETE /database_record_summaries/1.json
  def destroy
    @database_record_summary = DatabaseRecordSummary.find(params[:id])
    @database_record_summary.destroy

    respond_to do |format|
      format.html { redirect_to database_record_summaries_url }
      format.json { head :no_content }
    end
  end
end

class DatabaseRecordSummariesController < ApplicationController
  skip_before_filter :userAuthenticate
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

end

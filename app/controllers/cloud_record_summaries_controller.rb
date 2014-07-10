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
  end

  # GET /cloud_record_summaries/1
  # GET /cloud_record_summaries/1.json
  def show
    @cloud_record_summary = CloudRecordSummary.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @cloud_record_summary }
      format.xml { render :xml => @cloud_record_summary }
    end
  end

  # GET /cloud_record_summaries/search?VMUUID=string
  def search
    whereBuffer = String.new
    groupBuffer = String.new
    logger.info "Entering #search method."
    params[:doGraph] = "1"
    
    params.each do |param_k,param_v|
      if CloudRecordSummary.attrSearchable.include?(param_k) && param_v != ""
        logger.info "Got search parameter: #{param_k} ==> #{param_v}" 
        if ( whereBuffer != "" )
          whereBuffer += " AND "
        end
        whereBuffer += "#{param_k}=\"#{param_v}\"" 
      end
   end
    
    @cloud_record_summaries = CloudRecordSummary.joins(:site).paginate(:page=>params[:page], :per_page => config.itemsPerPageHTML).orderByParms('id desc',params).where(whereBuffer).all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @cloud_record_summaries }
      format.xml { render :xml => @cloud_record_summaries }
    end
  end
  

end

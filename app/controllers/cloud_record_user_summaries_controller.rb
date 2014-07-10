class CloudRecordUserSummariesController < CloudRecordSummariesController
  # GET /cloud_record_user_summaries
  # GET /cloud_record_user_summaries.json
  def index
    respond_to do |format|
      format.html {
        @cloud_record_user_summaries = CloudRecordUserSummary.paginate(:page=>params[:page], :per_page => config.itemsPerPageHTML).all
      }
      format.any(:xml,:json){
        @cloud_record_user_summaries = CloudRecordUserSummary.paginate(:page=>params[:page], :per_page => config.itemsPerPage).all
      }
    end
  end
  
  # GET /cloud_record_summaries/1
  # GET /cloud_record_summaries/1.json
  def show
    @cloud_record_user_summary = CloudRecordUserSummary.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @cloud_record_user_summary }
    end
  end
  
  # GET /cloud_record_user_summaries/search?VMUUID=string
  def search
    whereBuffer = String.new
    logger.info "Entering #search method."
    
    params.each do |param_k,param_v|
      if CloudRecordUserSummary.attrSearchable.include?(param_k) && param_v != ""
        logger.info "Got search parameter: #{param_k} ==> #{param_v}" 
        if ( whereBuffer != "" )
          whereBuffer += " AND "
        end
        whereBuffer += "#{param_k}=\"#{param_v}\"" 
      end
   end
    
    @cloud_record_user_summaries = CloudRecordUserSummary.joins(:site).paginate(:page=>params[:page], :per_page => config.itemsPerPageHTML).orderByParms('id desc',params).where(whereBuffer).all
    
    
    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @cloud_record_user_summaries }
      format.xml { render :xml => @cloud_record_user_summaries }
    end
  end
end

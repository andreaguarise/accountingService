class CpuGridSummariesController < ApplicationController
  # GET /cpu_grid_summaries
  # GET /cpu_grid_summaries.json
  def index
    @cpu_grid_summaries = CpuGridSummary.paginate(:page=>params[:page], :per_page => config.itemsPerPageHTML).all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @cpu_grid_summaries }
      format.xml { render :xml => @cpu_grid_summaries }
    end
  end
  
  def search
    whereBuffer = {}
    logger.info "Entering #search method."
    
    params.each do |param_k,param_v|
      if CpuGridSummary.attrSearchable.include?(param_k) && param_v != ""
        logger.info "Got search parameter: #{param_k} ==> #{param_v}" 
        whereBuffer[param_k]=param_v 
      end
   end
    
    @cpu_grid_summaries = CpuGridSummary.joins(:publisher, :publisher => :resource, :publisher => {:resource => :site} ).orderByParms('id desc',params).paginate(:page=>params[:page], :per_page => config.itemsPerPageHTML).where(whereBuffer)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @cpu_grid_summaries }
      format.xml { render :xml => @cpu_grid_summaries }
    end
  end

  # GET /cpu_grid_summaries/1
  # GET /cpu_grid_summaries/1.json
  def show
    @cpu_grid_summary = CpuGridSummary.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @cpu_grid_summary }
    end
  end

end

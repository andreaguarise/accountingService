class CpuGridIdsController < ApplicationController
  # GET /cpu_grid_ids
  # GET /cpu_grid_ids.json
  def index
    @cpu_grid_ids = CpuGridId.paginate(:page=>params[:page], :per_page => config.itemsPerPageHTML).all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @cpu_grid_ids }
      format.xml { render :xml => @cpu_grid_ids }
    end
  end
  
  def search
    whereBuffer = {}
    logger.info "Entering #search method."
    
    params.each do |param_k,param_v|
      if CpuGridId.attrSearchable.include?(param_k) && param_v != ""
        logger.info "Got search parameter: #{param_k} ==> #{param_v}" 
        whereBuffer[param_k]=param_v 
      end
   end
    
    @cpu_grid_ids = CpuGridId.joins(:blah_record, :batch_execute_record, :blah_record => :publisher, :blah_record => {:publisher => :resource}, :blah_record => {:publisher => {:resource => :site}} ).orderByParms('id desc',params).paginate(:page=>params[:page], :per_page => config.itemsPerPageHTML).where(whereBuffer)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @cpu_grid_ids }
      format.xml { render :xml => @cpu_grid_ids }
    end
  end

  # GET /cpu_grid_ids/1
  # GET /cpu_grid_ids/1.json
  def show
    @cpu_grid_id = CpuGridId.find_by_id(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @cpu_grid_id }
      format.json { render :xml => @cpu_grid_id }
    end
  end
end

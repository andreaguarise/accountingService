class CpuGridNormRecordsController < ApplicationController
  # GET /cpu_grid_norm_records
  # GET /cpu_grid_norm_records.json
  def index
    @cpu_grid_norm_records = CpuGridNormRecord.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @cpu_grid_norm_records }
      format.xml { render :xml => @cpu_grid_norm_records }
    end
  end
  
  def stats

    logger.info "test #{config.itemsPerPageHTML.to_s}"
    
    respond_to do |format|
      format.html # index.html.erb
    end
  end

  # GET /cpu_grid_norm_records/1
  # GET /cpu_grid_norm_records/1.json
  def show
    @cpu_grid_norm_record = CpuGridNormRecord.find_by_id(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @cpu_grid_norm_record }
      format.xml { render :xml => @cpu_grid_norm_record }
    end
  end

  # GET /cpu_grid_norm_records/1/edit
  def edit
    @cpu_grid_norm_record = CpuGridNormRecord.find(params[:id])
  end

 
end

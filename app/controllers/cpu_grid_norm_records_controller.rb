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
    
    @graphs ={}
    @graphs['summarize(sumSeries(faust.cpu_grid_norm_records_by_fqan.*.count),"1d")'] = "&from=-15days"
    @graphs['summarize(sumSeries(faust.cpu_grid_norm_records_by_fqan.*.cput),"1d")'] = "&from=-15days"
    @graphs['summarize(sumSeries(faust.cpu_grid_norm_records_by_fqan.*.wallt),"1d")'] = "&from=-15days"
    @graphs['summarize(faust.cpu_grid_norm_records_by_fqan.*.count,"1d")'] = "&from=-5days"

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

 
end

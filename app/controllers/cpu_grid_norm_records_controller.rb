class CpuGridNormRecordsController < ApplicationController
  # GET /cpu_grid_norm_records
  # GET /cpu_grid_norm_records.json
  def index
    @cpu_grid_norm_records = CpuGridNormRecord.paginate( :page=>params[:page], :per_page => config.itemsPerPage).all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @cpu_grid_norm_records }
      format.xml { render :xml => @cpu_grid_norm_records }
    end
  end
  
  def stats
    
    @graphs ={}
    @graphs['summarize(sumSeries(faust.cpu_grid_norm_records.by_site.*.by_vo.*.count),"1d")'] = "&from=-30days"
    @graphs['summarize(sumSeries(faust.cpu_grid_norm_records.by_site.*.by_vo.*.cpuDuration),"1d")'] = "&from=-30days"
    @graphs['summarize(sumSeries(faust.cpu_grid_norm_records.by_site.*.by_vo.*.wallDuration),"1d")'] = "&from=-30days"
    @graphs['summarize(faust.cpu_grid_norm_records.by_site.*.by_vo.*.count,"1d")'] = "&from=-60days"
    
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

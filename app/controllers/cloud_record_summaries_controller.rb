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
    
    relationBuffer = "date as ordered_date,sum(wallDuration/3600) as wall, sum(cpuDuration/3600) as cpu,sum(vmCount) as count, sum(cpuCount) as cpuCount, sum(networkInbound/1048576) as netIn,sum(networkOutBound/1048576) as netOut, sum(memory/1024) as mem"
    groupBuffer = "ordered_date"
    @cloud_record_summaries = CloudRecordSummary.joins(:site).paginate(:page=>params[:page], :per_page => config.itemsPerPageHTML).orderByParms('id desc',params).where(whereBuffer).all
    
    if params[:doGraph] == "1"
      min_max =  CloudRecordSummary.joins(:site).select("min(date) as minDate,max(date) as maxDate").where(whereBuffer)
      graph_ary = CloudRecordSummary.joins(:site).select(relationBuffer).where(whereBuffer).group(groupBuffer).order(:ordered_date)
      tableCpu = GoogleVisualr::DataTable.new
      tableMem = GoogleVisualr::DataTable.new
      tableCount = GoogleVisualr::DataTable.new
      tableNet = GoogleVisualr::DataTable.new
    
      # Add Column Headers
      tableCpu.new_column('date', 'Date' )
      tableCpu.new_column('number', 'wall time (h)')
      tableCpu.new_column('number', 'cpu time (h)')
      
      tableMem.new_column('date', 'Date' )
      tableMem.new_column('number', 'Memory (GB)')
      
      tableCount.new_column('date', 'Date' )
      tableCount.new_column('number', 'vm')
      tableCount.new_column('number', 'cpu')
    
      tableNet.new_column('date', 'Date' )
      tableNet.new_column('number', 'inbound net (MB)')
      tableNet.new_column('number', 'outbound net (MB)')
    
      graph_ary.each do |row|
        tableCpu.add_row([row.ordered_date.to_datetime,row.wall.to_i, row.cpu.to_i])
        tableMem.add_row([row.ordered_date.to_datetime,row.mem.to_i])
        tableCount.add_row([row.ordered_date.to_datetime,row.count.to_i, row.cpuCount.to_i])
        tableNet.add_row([row.ordered_date.to_datetime,row.netIn.to_i,row.netOut.to_i])
      end 
      optionCpu = { :width => 1100, :height => 215, :title => 'VM CPU/Wall time History', :hAxis => {:minValue => min_max.first.minDate.to_datetime, :maxValue => min_max.first.maxDate.to_datetime} }
      @chartCpu = GoogleVisualr::Interactive::AreaChart.new(tableCpu, optionCpu)
      optionMem = { :width => 1100, :height => 107, :title => 'VM RAM', :hAxis => {:minValue => min_max.first.minDate.to_datetime, :maxValue => min_max.first.maxDate.to_datetime} }
      @chartMem = GoogleVisualr::Interactive::AreaChart.new(tableMem, optionMem)
      optionCount = { :width => 1100, :height => 107, :title => 'VM/CPU Count', :hAxis => {:minValue => min_max.first.minDate.to_datetime, :maxValue => min_max.first.maxDate.to_datetime} }
      @chartCount = GoogleVisualr::Interactive::AreaChart.new(tableCount, optionCount)
      optionNet = { :width => 1100, :height => 215, :title => 'VM Network History', :hAxis => {:minValue => min_max.first.minDate.to_datetime, :maxValue => min_max.first.maxDate.to_datetime} }
      @chartNet = GoogleVisualr::Interactive::AreaChart.new(tableNet, optionNet)
    end
    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @cloud_record_summaries }
      format.xml { render :xml => @cloud_record_summaries }
    end
  end


end

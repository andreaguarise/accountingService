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
    whereBuffer += "status=\"RUNNING\" AND date > \"2014-03-10\""
    groupBuffer = ["ordered_date","local_user"]
    logger.info "Entering #search method."
    params[:doGraph] = "1"
    
    params.each do |param_k,param_v|
      if CloudRecordUserSummary.attrSearchable.include?(param_k) && param_v != ""
        logger.info "Got search parameter: #{param_k} ==> #{param_v}" 
        if ( whereBuffer != "" )
          whereBuffer += " AND "
        end
        whereBuffer += "#{param_k}=\"#{param_v}\"" 
      end
   end
    
    relationBuffer = "local_user,date as ordered_date,sum(wallDuration/3600) as wall, sum(cpuDuration/3600) as cpu,sum(vmCount) as count, sum(cpuCount) as cpuCount, sum(networkInbound/1073741824) as netIn,sum(networkOutBound/1073741824) as netOut, sum(memory/1024) as mem"
    @cloud_record_user_summaries = CloudRecordUserSummary.joins(:site).paginate(:page=>params[:page], :per_page => config.itemsPerPageHTML).orderByParms('id desc',params).where(whereBuffer).all
    
    if params[:doGraph] == "1"
      users = CloudRecordUserSummary.joins(:site).select("local_user").group(["local_user",:site_id]).where(whereBuffer).all
      dates = CloudRecordUserSummary.joins(:site).select("date").group([:date]).where(whereBuffer).all
      min_max =  CloudRecordUserSummary.joins(:site).select("min(date) as minDate,max(date) as maxDate").where(whereBuffer)
      graph_ary = CloudRecordUserSummary.joins(:site).select(relationBuffer).where(whereBuffer).group(groupBuffer).order(:ordered_date)
      tableCpu = GoogleVisualr::DataTable.new
      #tableMem = GoogleVisualr::DataTable.new
      #tableCount = GoogleVisualr::DataTable.new
      tableNetIn = GoogleVisualr::DataTable.new
      tableNetOut = GoogleVisualr::DataTable.new
      tableRatio = GoogleVisualr::DataTable.new
    
      # Add Column Headers
      user_id={}
      id_u = 1
      tableCpu.new_column('date', 'Date' )
      tableNetIn.new_column('date', 'Date' )
      tableNetOut.new_column('date', 'Date' )
      tableRatio.new_column('date', 'Date' )
      users.each do |user|
        user_id[user.local_user] = id_u
        tableCpu.new_column('number',user.local_user)
        tableNetIn.new_column('number',user.local_user)
        tableNetOut.new_column('number',user.local_user)
        tableRatio.new_column('number',user.local_user)
        id_u = id_u + 1
      end
      
      date_id={}
      id_d = 0
      dates.each do |date|
        date_id[date.date] = id_d
        tableCpu.add_rows(1)
        tableNetIn.add_rows(1)
        tableNetOut.add_rows(1)
        tableRatio.add_rows(1)
        user_id.each do |uk,uv|
          tableCpu.set_cell(id_d,uv,0)
          tableNetIn.set_cell(id_d,uv,0)
          tableNetOut.set_cell(id_d,uv,0)
          tableRatio.set_cell(id_d,uv,0)
        end
        tableCpu.set_cell(id_d, 0, date.date.to_datetime)
        tableNetIn.set_cell(id_d, 0, date.date.to_datetime)
        tableNetOut.set_cell(id_d, 0, date.date.to_datetime)
        tableRatio.set_cell(id_d, 0, date.date.to_datetime)
        id_d = id_d + 1
      end
      graph_ary.each do |row|
        logger.debug "#{row.ordered_date} --> #{date_id[row.ordered_date]}, #{row.local_user} --> #{user_id[row.local_user]}, #{row.cpuCount}"
        tableCpu.set_cell(date_id[row.ordered_date],user_id[row.local_user],row.cpuCount.to_i)
        tableNetIn.set_cell(date_id[row.ordered_date],user_id[row.local_user],row.netIn.to_i)
        tableNetOut.set_cell(date_id[row.ordered_date],user_id[row.local_user],row.netOut.to_i)
        tableRatio.set_cell(date_id[row.ordered_date],user_id[row.local_user],(row.cpu/row.wall)*100)
      end 
      optionCpu = { :width => 1100, :height => 300, :title => 'Number of CPUs', :vAxis => {:logScale => true}, :hAxis => {:minValue => min_max.first.minDate.to_datetime, :maxValue => min_max.first.maxDate.to_datetime} }
      @chartCpu = GoogleVisualr::Interactive::LineChart.new(tableCpu, optionCpu)
      optionNetIn = { :width => 1100, :height => 150, :title => 'Network Inbound (GB)', :vAxis => {:logScale => true}, :hAxis => {:minValue => min_max.first.minDate.to_datetime, :maxValue => min_max.first.maxDate.to_datetime} }
      @chartNetIn = GoogleVisualr::Interactive::LineChart.new(tableNetIn, optionNetIn)
      optionNetOut = { :width => 1100, :height => 150, :title => 'Network Outbound (GB)',:vAxis => {:logScale => true}, :hAxis => {:minValue => min_max.first.minDate.to_datetime, :maxValue => min_max.first.maxDate.to_datetime} }
      @chartNetOut = GoogleVisualr::Interactive::LineChart.new(tableNetOut, optionNetOut)
      optionRatio = { :width => 1100, :height => 150, :title => 'CpuTime/WallTime (%)', :hAxis => {:minValue => min_max.first.minDate.to_datetime, :maxValue => min_max.first.maxDate.to_datetime} }
      @chartRatio = GoogleVisualr::Interactive::LineChart.new(tableRatio, optionRatio)
      
    end
    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @cloud_record_user_summaries }
      format.xml { render :xml => @cloud_record_user_summaries }
    end
  end
end
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
  
  # GET /cloud_record_user_summaries/search?VMUUID=string
  def search
    whereBuffer = String.new
    groupBuffer = ["ordered_date","table_string"]
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
    
    relationBuffer = "record_date as ordered_date, concat_ws('_',sites.name,resources.name, scheme_name) as table_string,sum(rows) as rows"
    @database_record_summaries = DatabaseRecordSummary.joins(:site).paginate(:page=>params[:page], :per_page => config.itemsPerPageHTML).orderByParms('id desc',params).where(whereBuffer).all
    
    if params[:doGraph] == "1"
      schemes = DatabaseRecordSummary.joins(:site).select("concat_ws('_',sites.name,resources.name, scheme_name) as table_string").where(whereBuffer).uniq.all
      dates = DatabaseRecordSummary.joins(:site).select("record_date").group([:record_date]).where(whereBuffer).all
      min_max =  DatabaseRecordSummary.joins(:site).select("min(record_date) as minDate,max(record_date) as maxDate").where(whereBuffer)
      graph_ary = DatabaseRecordSummary.joins(:site).select(relationBuffer).where(whereBuffer).group(groupBuffer).order(:ordered_date)
      tableRows = GoogleVisualr::DataTable.new
      ##tableNetIn = GoogleVisualr::DataTable.new
      #tableNetOut = GoogleVisualr::DataTable.new
      #tableRatio = GoogleVisualr::DataTable.new
    
      # Add Column Headers
      scheme_id={}
      id_s = 1
      tableRows.new_column('date', 'Date' )
      #tableNetIn.new_column('date', 'Date' )
      #tableNetOut.new_column('date', 'Date' )
      #tableRatio.new_column('date', 'Date' )
      schemes.each do |scheme|
        scheme_id[scheme.table_string] = id_s
        tableRows.new_column('number',scheme.table_string)
        #tableNetIn.new_column('number',user.local_user)
        #tableNetOut.new_column('number',user.local_user)
        #tableRatio.new_column('number',user.local_user)
        id_s = id_s + 1
      end
      
      date_id={}
      id_d = 0
      dates.each do |date|
        date_id[date.record_date] = id_d
        tableRows.add_rows(1)
        #tableNetIn.add_rows(1)
        #tableNetOut.add_rows(1)
        #tableRatio.add_rows(1)
        scheme_id.each do |sk,sv|
          tableRows.set_cell(id_d,sv,0)
          #tableNetIn.set_cell(id_d,uv,0)
          ##tableNetOut.set_cell(id_d,uv,0)
          #tableRatio.set_cell(id_d,uv,0)
        end
        tableRows.set_cell(id_d, 0, date.record_date.to_datetime)
        #tableNetIn.set_cell(id_d, 0, date.date.to_datetime)
        #tableNetOut.set_cell(id_d, 0, date.date.to_datetime)
        #tableRatio.set_cell(id_d, 0, date.date.to_datetime)
        id_d = id_d + 1
      end
      graph_ary.each do |row|
        logger.debug "#{row.ordered_date} --> #{date_id[row.ordered_date]}, #{row.table_string} --> #{scheme_id[row.table_string]}, #{row.rows}"
        tableRows.set_cell(date_id[row.ordered_date],scheme_id[row.table_string],row.rows.to_i)
        #tableNetIn.set_cell(date_id[row.ordered_date],user_id[row.local_user],row.netIn.to_i)
        #tableNetOut.set_cell(date_id[row.ordered_date],user_id[row.local_user],row.netOut.to_i)
        #tableRatio.set_cell(date_id[row.ordered_date],user_id[row.local_user],(row.cpu/row.wall)*100)
      end 
      optionRows = { :width => 1100, :height => 300, :title => 'Number of rows', :vAxis => {:logScale => true}, :hAxis => {:minValue => min_max.first.minDate.to_datetime, :maxValue => min_max.first.maxDate.to_datetime} }
      @chartRows = GoogleVisualr::Interactive::LineChart.new(tableRows, optionRows)
      #optionNetIn = { :width => 1100, :height => 150, :title => 'Network Inbound (GB)', :vAxis => {:logScale => true}, :hAxis => {:minValue => min_max.first.minDate.to_datetime, :maxValue => min_max.first.maxDate.to_datetime} }
      #@chartNetIn = GoogleVisualr::Interactive::LineChart.new(tableNetIn, optionNetIn)
      #optionNetOut = { :width => 1100, :height => 150, :title => 'Network Outbound (GB)',:vAxis => {:logScale => true}, :hAxis => {:minValue => min_max.first.minDate.to_datetime, :maxValue => min_max.first.maxDate.to_datetime} }
      #@chartNetOut = GoogleVisualr::Interactive::LineChart.new(tableNetOut, optionNetOut)
      #optionRatio = { :width => 1100, :height => 150, :title => 'CpuTime/WallTime (%)', :hAxis => {:minValue => min_max.first.minDate.to_datetime, :maxValue => min_max.first.maxDate.to_datetime} }
      #@chartRatio = GoogleVisualr::Interactive::LineChart.new(tableRatio, optionRatio)
      
    end
    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @cloud_record_user_summaries }
      format.xml { render :xml => @cloud_record_user_summaries }
    end
  end

end

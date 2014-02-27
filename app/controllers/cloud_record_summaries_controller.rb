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
    
    params.each do |param_k,param_v|
      if CloudRecordSummary.attrSearchable.include?(param_k) && param_v != ""
        logger.info "Got search parameter: #{param_k} ==> #{param_v}" 
        if ( whereBuffer != "" )
          whereBuffer += " AND "
        end
        whereBuffer += "#{param_k}=\"#{param_v}\"" 
      end
   end
    
    relationBuffer = "date as ordered_date,sum(wallDuration/60) as wall,sum(vmCount) as count,sum(networkInbound/1048576) as netIn,sum(networkOutBound/1048576) as netOut"
    groupBuffer = "ordered_date"
    @cloud_record_summaries = CloudRecordSummary.paginate(:page=>params[:page], :per_page => config.itemsPerPageHTML).orderByParms('id desc',params).where(whereBuffer).all
    
    if params[:doGraph] == "1"
      min_max =  CloudRecordSummary.select("min(date) as minDate,max(date) as maxDate").where(whereBuffer)
      graph_ary = CloudRecordSummary.select(relationBuffer).where(whereBuffer).group(groupBuffer).order(:ordered_date)
      tableCpu = GoogleVisualr::DataTable.new
      tableCount = GoogleVisualr::DataTable.new
      tableNet = GoogleVisualr::DataTable.new
    
      # Add Column Headers
      tableCpu.new_column('date', 'Date' )
      tableCpu.new_column('number', 'wall time (min)')
      
      tableCount.new_column('date', 'Date' )
      tableCount.new_column('number', 'count')
    
      tableNet.new_column('date', 'Date' )
      tableNet.new_column('number', 'inbound net (MB)')
      tableNet.new_column('number', 'outbound net (MB)')
    
      graph_ary.each do |row|
        tableCpu.add_row([row.ordered_date.to_datetime,row.wall.to_i])
        tableCount.add_row([row.ordered_date.to_datetime,row.count.to_i])
        tableNet.add_row([row.ordered_date.to_datetime,row.netIn.to_i,row.netOut.to_i])
      end 
      optionCpu = { :width => 1100, :height => 215, :title => 'VM CPU History', :hAxis => {:minValue => min_max.first.minDate.to_datetime, :maxValue => min_max.first.maxDate.to_datetime} }
      @chartCpu = GoogleVisualr::Interactive::AreaChart.new(tableCpu, optionCpu)
      optionCount = { :width => 1100, :height => 215, :title => 'VM Count', :hAxis => {:minValue => min_max.first.minDate.to_datetime, :maxValue => min_max.first.maxDate.to_datetime} }
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


  # GET /cloud_record_summaries/new
  # GET /cloud_record_summaries/new.json
  def new
    @cloud_record_summary = CloudRecordSummary.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @cloud_record_summary }
    end
  end
 

  # GET /cloud_record_summaries/1/edit
  def edit
    @cloud_record_summary = CloudRecordSummary.find(params[:id])
  end

  # POST /cloud_record_summaries
  # POST /cloud_record_summaries.json
  def create
    @cloud_record_summary = CloudRecordSummary.new(params[:cloud_record_summary])

    respond_to do |format|
      if @cloud_record_summary.save
        format.html { redirect_to @cloud_record_summary, :notice => 'Cloud record summary was successfully created.' }
        format.json { render :json => @cloud_record_summary, :status => :created, :location => @cloud_record_summary }
      else
        format.html { render :action => "new" }
        format.json { render :json => @cloud_record_summary.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /cloud_record_summaries/1
  # PUT /cloud_record_summaries/1.json
  def update
    @cloud_record_summary = CloudRecordSummary.find(params[:id])

    respond_to do |format|
      if @cloud_record_summary.update_attributes(params[:cloud_record_summary])
        format.html { redirect_to @cloud_record_summary, :notice => 'Cloud record summary was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @cloud_record_summary.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /cloud_record_summaries/1
  # DELETE /cloud_record_summaries/1.json
  def destroy
    @cloud_record_summary = CloudRecordSummary.find(params[:id])
    @cloud_record_summary.destroy

    respond_to do |format|
      format.html { redirect_to cloud_record_summaries_url }
      format.json { head :no_content }
    end
  end
end

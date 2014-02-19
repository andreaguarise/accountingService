class CloudRecordsController < ApplicationController
  skip_before_filter :userAuthenticate
  skip_before_filter :publisherAuthenticate, :only => [:stats]
  # GET /cloud_records
  # GET /cloud_records.json
  # GET /cloud_records.xml
  def index
    respond_to do |format|
      format.html {
        @cloud_records = CloudRecord.includes(:publisher,:publisher => :resource, :publisher => {:resource => :site}).paginate(:page=>params[:page], :per_page => config.itemsPerPageHTML).orderByParms('id desc',params)
      }
      format.any(:xml,:json){
        @cloud_records = CloudRecord.includes(:publisher,:publisher => :resource, :publisher => {:resource => :site}).paginate(:page=>params[:page], :per_page => config.itemsPerPage).all
      }
    end
    respond_to do |format|
      format.html # index.html.erb
      format.json {
        render :json => @cloud_records.to_json(:include => { :site => {:only => :name} , :resource => {:only => :name} } )
      }
      format.xml {
        render :xml => @cloud_records.to_xml(:include => { :site => {:only => :name} , :resource => {:only => :name} } )
      }
    end
  end

  # GET /cloud_records/1
  # GET /cloud_records/1.json
  # GET /cloud_records/1.xml
  def show
    @cloud_record = CloudRecord.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json {
        render :json => @cloud_record.to_json(:include => { :site => {:only => :name} , :resource => {:only => :name} } )
      }
      format.xml {
        render :xml => @cloud_record.to_xml(:include => { :site => {:only => :name} , :resource => {:only => :name} } )
      }
    end
  end

  # GET /cloud_records/stats
  # GET /cloud_records/stats.json
  # GET /cloud_records/stats.xml
  def stats
    @stats = {}
    @stats[:records_count]= CloudRecord.count
    @stats[:records_pages]= (CloudRecord.count/250.0).ceil
    @stats[:earliest_record] = CloudRecord.minimum(:endTime)
    @stats[:latest_record] = CloudRecord.maximum(:endTime)
    startFrom = "2007-04-06".to_date
    if @stats[:latest_record]
      startFrom = @stats[:latest_record].to_date-90 
    end
    endFrom = @stats[:latest_record]

    data_table = GoogleVisualr::DataTable.new
    # Add Column Headers
    data_table.new_column('date', 'date' )
    data_table.new_column('number', 'running')
    data_table.new_column('number', 'not running')

    # Add Rows and Values

    all_ary = CloudRecord.select("date(endTime)as ordered_date,hour(endTime) as ordered_hour,minute(endTime) as ordered_minute,count(id) as all_count").group('ordered_date,ordered_hour,ordered_minute').order('ordered_date')  
    running_ary = CloudRecord.select("date(endTime)as ordered_date,hour(endTime) as ordered_hour,minute(endTime) as ordered_minute,count(localVMID) as running_count").where("status=\"RUNNING\"").group('ordered_date,ordered_hour,ordered_minute').order('ordered_date')
    
    graph_hash = {}
    
    all_ary.each do |row|
      graph_hash[row.ordered_date] = row.all_count
    end
    
    running_ary.each do |row|
      data_table.add_row([row.ordered_date.to_date,row.running_count,graph_hash[row.ordered_date]-row.running_count])
    end
    
    option = { :width => 1100, :height => 650, :title => 'Running VMs', :hAxis => {:minValue => startFrom, :maxValue => endFrom }}
    @chart = GoogleVisualr::Interactive::AreaChart.new(data_table, option)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @stats }
      format.xml { render :xml => @stats }
    end
  end

  # GET /cloud_records/search?VMUUID=string
  def search
    whereBuffer = String.new
    groupBuffer = String.new
    relationBuffer = "endTime as ordered_date,wallDuration/60 as wall,cpuDuration/60 as cpu,networkInbound/1048576 as netIn,networkOutBound/1048576 as netOut"
    case
    when params.include?(:VMUUID) then
      @cloud_records = CloudRecord.paginate(:page=>params[:page], :per_page => config.itemsPerPageHTML).orderByParms('id desc',params).find_all_by_VMUUID(params[:VMUUID])
      whereBuffer = "VMUUID=\"#{params[:VMUUID]}\""
    when params.include?(:local_user) then
      @cloud_records = CloudRecord.paginate(:page=>params[:page], :per_page => config.itemsPerPageHTML).orderByParms('id desc',params).find_all_by_local_user(params[:local_user])
      whereBuffer = "local_user=\"#{params[:local_user]}\""
      groupBuffer = "ordered_date"
      relationBuffer = "endTime as ordered_date,sum(wallDuration)/60 as wall,sum(cpuDuration)/60 as cpu,sum(networkInbound/1048576) as netIn, sum(networkOutBound/1048576) as netOut"
    when params.include?(:local_group) then
      @cloud_records = CloudRecord.paginate(:page=>params[:page], :per_page => config.itemsPerPageHTML).orderByParms('id desc',params).find_all_by_local_group(params[:local_group])
      whereBuffer = "local_group=\"#{params[:local_group]}\""
      groupBuffer = "ordered_date"
      relationBuffer = "endTime as ordered_date,sum(wallDuration)/60 as wall,sum(cpuDuration)/60 as cpu,sum(networkInbound/1048576) as netIn, sum(networkOutBound/1048576) as netOut"
    when params.include?(:localVMID) then
      @cloud_records = CloudRecord.paginate(:page=>params[:page], :per_page => config.itemsPerPageHTML).orderByParms('id desc',params).find_all_by_localVMID(params[:localVMID])
      whereBuffer = "localVMID=\"#{params[:localVMID]}\""
    else
      #@cloud_records.find_all
    end  
      
      
    if params[:doGraph] == "true"
      min_max =  CloudRecord.select("min(endTime) as minDate,max(endTime) as maxDate").where(whereBuffer)
      graph_ary = CloudRecord.select(relationBuffer).where(whereBuffer).group(groupBuffer).order(:ordered_date)
      tableCpu = GoogleVisualr::DataTable.new
      tableNet = GoogleVisualr::DataTable.new
    
      # Add Column Headers
      tableCpu.new_column('date', 'Date' )
      tableCpu.new_column('number', 'wall time (min)')
      tableCpu.new_column('number', 'cpu time (min)')
    
      tableNet.new_column('date', 'Date' )
      tableNet.new_column('number', 'inbound net (MB)')
      tableNet.new_column('number', 'outbound net (MB)')
    
      graph_ary.each do |row|
        tableCpu.add_row([row.ordered_date.to_datetime,row.wall.to_i,row.cpu.to_i])
        tableNet.add_row([row.ordered_date.to_datetime,row.netIn.to_i,row.netOut.to_i])
      end 
      optionCpu = { :width => 1100, :height => 325, :title => 'VM CPU History', :hAxis => {:minValue => min_max.first.minDate.to_datetime, :maxValue => min_max.first.maxDate.to_datetime} }
      @chartCpu = GoogleVisualr::Interactive::AreaChart.new(tableCpu, optionCpu)
      optionNet = { :width => 1100, :height => 325, :title => 'VM Network History', :hAxis => {:minValue => min_max.first.minDate.to_datetime, :maxValue => min_max.first.maxDate.to_datetime} }
      @chartNet = GoogleVisualr::Interactive::AreaChart.new(tableNet, optionNet)
    end
    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @cloud_record.to_json(:include => { :site => {:only => :name} , :resource => {:only => :name} } ) }
      format.xml { render :xml => @cloud_record.to_xml(:include => { :site => {:only => :name} , :resource => {:only => :name} } )}
    end
  end

  # GET /cloud_records/new
  # GET /cloud_records/new.json
  def new
    @cloud_record = CloudRecord.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @cloud_record }
    end
  end

  # GET /cloud_records/1/edit
  def edit
    @cloud_record = CloudRecord.find(params[:id])
  end

  # POST /cloud_records
  # POST /cloud_records.json
  def create
    if params[:cloud_record][:resource_name] #JSON post
      params[:resource_name] = params[:cloud_record].delete(:resource_name)
    end
    @cloud_record = CloudRecord.new(params[:cloud_record])
    @cloud_record.publisher = Publisher.find_by_token(session[:token])
    logger.info "Received API-KEY:#{session[:token]}, which maps to :#{@cloud_record.publisher.hostname}"

    respond_to do |format|
      if @cloud_record.save
        format.html { redirect_to @cloud_record, :notice => 'Cloud record was successfully created.' }
        format.json { render :json => @cloud_record, :status => :created, :location => @cloud_record }
        format.xml { render :xml => @cloud_record, :status => :created, :location => @cloud_record }
      else
        format.html { render :action => "new" }
        format.json { render :json => @cloud_record.errors, :status => :unprocessable_entity }
        format.xml { render :xml => @cloud_record.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /cloud_records/1
  # PUT /cloud_records/1.json
  def update
    if params[:cloud_record][:resource_name] #JSON post
      params[:resource_name] = params[:cloud_record].delete(:resource_name)
    end
    if params[:cloud_record][:site] #JSON post
      params[:site] = params[:cloud_record].delete(:site)
    end

    @cloud_record = CloudRecord.find(params[:id])
    skipMassAssign :cloud_record
    if params[:cloud_record][:resource]
      params[:cloud_record].delete(:resource)
    end

    respond_to do |format|
      if @cloud_record.update_attributes(params[:cloud_record])
        format.html { redirect_to @cloud_record, :notice => 'Cloud record was successfully updated.' }
        format.json { head :no_content }
        format.xml { head :no_content }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @cloud_record.errors, :status => :unprocessable_entity }
        format.xml { render :json => @cloud_record.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /cloud_records/1
  # DELETE /cloud_records/1.json
  def destroy
    @cloud_record = CloudRecord.find(params[:id])
    @cloud_record.destroy

    respond_to do |format|
      format.html { redirect_to cloud_records_url }
      format.json { head :no_content }
      format.xml { head :no_content }
    end
  end
end

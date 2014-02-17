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

    data_table = GoogleVisualr::DataTable.new
    # Add Column Headers
    data_table.new_column('date', 'date' )
    data_table.new_column('number', 'started')
    data_table.new_column('number', 'started-ended')
    data_table.new_column('number', 'running')
    #data_table.new_column('number', 'wallDuration')

    # Add Rows and Values

    partialRunning = {}
    running = {}
    incremental = 0

    started_ary = CloudRecord.select("date(startTime) as _date,count(id) as _count").group('date(startTime)')
    ended_ary = CloudRecord.group('date(endTime)').count

    started_ary.each do |r|
      if ended_ary[r["_date"]]
      partialRunning[r["_date"]] = r["_count"]-ended_ary[r["_date"]]
      else
      partialRunning[r["_date"]] = r["_count"]
      end
      incremental = incremental + partialRunning[r["_date"]]
      running[r["_date"]] = incremental
      #puts "date:#{date}, running:#{running[date]}  --->  partial: #{partial[date]}"
      data_table.add_row([r["_date"].to_date,r["_count"],partialRunning[r["_date"]],running[r["_date"]]])
    end
    
    option = { :width => 1100, :height => 650, :title => 'Running VMs' }
    @chart = GoogleVisualr::Interactive::AreaChart.new(data_table, option)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @stats }
      format.xml { render :xml => @stats }
    end
  end

  # GET /cloud_records/search?VMUUID=string
  def search
    @cloud_records = CloudRecord.paginate(:page=>params[:page], :per_page => config.itemsPerPageHTML).orderByParms('id desc',params).find_all_by_VMUUID(params[:VMUUID])

    if params[:doGraph] == "true"
      graph_ary = CloudRecord.select("date(endTime) as ordered_date,wallDuration/60 as wall,cpuDuration/60 as cpu").group('date(startTime)').where("VMUUID=\"#{params[:VMUUID]}\"")
      table = GoogleVisualr::DataTable.new
    
      # Add Column Headers
      table.new_column('date', 'Date' )
      table.new_column('number', 'wall time (min)')
      table.new_column('number', 'cpu time (min)')
    
    
      graph_ary.each do |row|
        table.add_row([row.ordered_date.to_date,row.wall.to_i,row.cpu.to_i])
      end 
      option1 = { :width => 1100, :height => 650, :title => 'VM History' }
      @chart1 = GoogleVisualr::Interactive::AreaChart.new(table, option1)
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

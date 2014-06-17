class GridCpuRecordsController < ApplicationController
  skip_before_filter :userAuthenticate
  skip_before_filter :publisherAuthenticate, :only => [:stats]
  # GET /grid_cpu_records
  # GET /grid_cpu_records.json
  def index
    @grid_cpu_records = GridCpuRecord.includes(:blah_record, :batch_execute_record, :blah_record => :publisher, :blah_record => {:publisher => :resource}, :blah_record => {:publisher => {:resource => :site}} ).orderByParms('id desc',params).paginate(:page=>params[:page], :per_page => config.itemsPerPageHTML)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @grid_cpu_records }
      format.xml { render :xml => @grid_cpu_records }
    end
  end
  
  # GET /grid_cpu_records/stats
  # GET /grid_cpu_records/stats.json
  def stats
    @stats = {}
    @stats[:records_count]= GridCpuRecord.count
    @stats[:earliest_record]= BlahRecord.minimum(:recordDate)
    @stats[:latest_record]= BlahRecord.maximum(:recordDate)
    startFrom = "2007-04-06".to_date
    if @stats[:latest_record]
      startFrom = @stats[:latest_record].to_date-90 
    end
    #GRAPH for latest 3 months.
    @results1 = GridCpuRecord.find_by_sql("SELECT date(blah_records.recordDate) as ordered_date, count(grid_cpu_records.id) as count, sum(batch_execute_records.resourceUsed_walltime)/3600 as wall, sum(batch_execute_records.resourceUsed_cput)/3600 as cpu FROM grid_cpu_records INNER JOIN batch_execute_records ON grid_cpu_records.batch_execute_record_id = batch_execute_records.id INNER JOIN blah_records ON grid_cpu_records.blah_record_id = blah_records.id WHERE blah_records.recordDate >= \"#{startFrom.to_s}\" GROUP BY ordered_date")

    table = GoogleVisualr::DataTable.new
    
    # Add Column Headers
    table.new_column('date', 'Date' )
    table.new_column('number', 'jobs')
    table.new_column('number', 'wall time (h)')
    table.new_column('number', 'cpu time (h)')
    
    
    @results1.each do |result1|
      table.add_row([result1.ordered_date.to_date,result1.count.to_i,result1.wall.to_i,result1.cpu.to_i])
    end 
    
    option1 = { :width => 1100, :height => 650, :title => 'Grid Jobs' }
    @chart1 = GoogleVisualr::Interactive::AreaChart.new(table, option1)
   

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @stats }
      format.xml { render :xml => @stats }
    end
  end
  
  def search
    whereBuffer = {}
    logger.info "Entering #search method."
    
    params.each do |param_k,param_v|
      if GridCpuRecord.attrSearchable.include?(param_k) && param_v != ""
        logger.info "Got search parameter: #{param_k} ==> #{param_v}" 
        whereBuffer[param_k]=param_v 
      end
   end
    
    @grid_cpu_records = GridCpuRecord.joins(:blah_record, :batch_execute_record, :blah_record => :publisher, :blah_record => {:publisher => :resource}, :blah_record => {:publisher => {:resource => :site}} ).orderByParms('id desc',params).paginate(:page=>params[:page], :per_page => config.itemsPerPageHTML).where(whereBuffer)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @grid_cpu_records }
      format.xml { render :xml => @grid_cpu_records }
    end
  end

  # GET /grid_cpu_records/1
  # GET /grid_cpu_records/1.json
  def show
    @grid_cpu_record = GridCpuRecord.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @grid_cpu_record }
      format.xml { render :xml => @grid_cpu_record }
    end
  end

  # GET /grid_cpu_records/new
  # GET /grid_cpu_records/new.json
  def new
    @grid_cpu_record = GridCpuRecord.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @grid_cpu_record }
      format.xml { render :xml => @grid_cpu_record }
    end
  end

  # GET /grid_cpu_records/1/edit
  def edit
    @grid_cpu_record = GridCpuRecord.find(params[:id])
  end

  # POST /grid_cpu_records
  # POST /grid_cpu_records.json
  def create
    @grid_cpu_record = GridCpuRecord.new(params[:grid_cpu_record])

    respond_to do |format|
      if @grid_cpu_record.save
        format.html { redirect_to @grid_cpu_record, :notice => 'Grid cpu record was successfully created.' }
        format.json { render :json => @grid_cpu_record, :status => :created, :location => @grid_cpu_record }
        format.xml { render :xml => @grid_cpu_record, :status => :created, :location => @grid_cpu_record }
      else
        format.html { render :action => "new" }
        format.json { render :json => @grid_cpu_record.errors, :status => :unprocessable_entity }
        format.xml { render :xml => @grid_cpu_record.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /grid_cpu_records/1
  # PUT /grid_cpu_records/1.json
  def update
    @grid_cpu_record = GridCpuRecord.find(params[:id])

    respond_to do |format|
      if @grid_cpu_record.update_attributes(params[:grid_cpu_record])
        format.html { redirect_to @grid_cpu_record, :notice => 'Grid cpu record was successfully updated.' }
        format.json { head :no_content }
        format.xml { head :no_content }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @grid_cpu_record.errors, :status => :unprocessable_entity }
        format.xml { render :xml => @grid_cpu_record.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /grid_cpu_records/1
  # DELETE /grid_cpu_records/1.json
  def destroy
    @grid_cpu_record = GridCpuRecord.find(params[:id])
    @grid_cpu_record.destroy

    respond_to do |format|
      format.html { redirect_to grid_cpu_records_url }
      format.json { head :no_content }
      format.xml { head :no_content }
    end
  end
end

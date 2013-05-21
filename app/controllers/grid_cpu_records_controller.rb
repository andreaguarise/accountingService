class GridCpuRecordsController < ApplicationController
  skip_before_filter :userAuthenticate
  skip_before_filter :publisherAuthenticate, :only => [:stats]
  # GET /grid_cpu_records
  # GET /grid_cpu_records.json
  def index
    @grid_cpu_records = GridCpuRecord.paginate :page=>params[:page], :order=>'id desc', :per_page => 20

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @grid_cpu_records }
    end
  end
  
  # GET /grid_cpu_records/stats
  # GET /grid_cpu_records/stats.json
  def stats
    @stats = {}
    @stats[:records_count]= GridCpuRecord.count
    @stats[:earliest_record]= BlahRecord.minimum(:recordDate)
    @stats[:latest_record]= BlahRecord.maximum(:recordDate)
    startFrom = @stats[:latest_record].to_date-90
    #GRAPH for latest 3 months.
    @results1 = GridCpuRecord.find_by_sql("SELECT date(blah_records.recordDate) as ordered_date, count(grid_cpu_records.id) as count FROM grid_cpu_records INNER JOIN torque_execute_records ON grid_cpu_records.recordlike_id = torque_execute_records.id INNER JOIN blah_records ON grid_cpu_records.blah_record_id = blah_records.id WHERE blah_records.recordDate >= \"#{startFrom.to_s}\" GROUP BY ordered_date")

    table = GoogleVisualr::DataTable.new
    #table2 = GoogleVisualr::DataTable.new
    
    
    # Add Column Headers
    table.new_column('date', 'Date' )
    table.new_column('number', 'count')
    
    #table2.new_column('date', 'Date' )
    #table2.new_column('number', 'sum_wall')
    
    
    @results1.each do |result1|
      table.add_row([result1.ordered_date.to_date,result1.count.to_i])
      #table2.add_row([result1.ordered_date.to_date,result1.sum_wall.to_i])
    end 
    

    
    option1 = { :width => 600, :height => 300, :title => 'Ended Jobs' }
    @chart1 = GoogleVisualr::Interactive::AreaChart.new(table, option1)
    
    #option2 = { :width => 600, :height => 300, :title => 'Wall time' }
    #@chart2 = GoogleVisualr::Interactive::AreaChart.new(table2, option2)

    

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @stats }
      format.xml { render :xml => @stats }
    end
  end

  # GET /grid_cpu_records/1
  # GET /grid_cpu_records/1.json
  def show
    @grid_cpu_record = GridCpuRecord.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @grid_cpu_record }
    end
  end

  # GET /grid_cpu_records/new
  # GET /grid_cpu_records/new.json
  def new
    @grid_cpu_record = GridCpuRecord.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @grid_cpu_record }
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
      else
        format.html { render :action => "new" }
        format.json { render :json => @grid_cpu_record.errors, :status => :unprocessable_entity }
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
      else
        format.html { render :action => "edit" }
        format.json { render :json => @grid_cpu_record.errors, :status => :unprocessable_entity }
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
    end
  end
end

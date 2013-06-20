class LocalCpuRecordsController < ApplicationController
  skip_before_filter :userAuthenticate
  # GET /local_cpu_records
  # GET /local_cpu_records.json
  # GET /local_cpu_records.xml
  def index
    respond_to do |format|
      format.html {
        @bvalues_hash = {}
        #this snippet associates each BatchExecuteRecord to is own benchmark_value on the base of the date, taking the nearest
        #(respect to recordDate) benchmark_values.value found in the benchmark_values table. association is done through the publisher_id.
        #note that the limitation of the current implementation is that just one benchmark type per publisher would actually work. FIXME for this
        #limitation is needed.
        @local_cpu_records = LocalCpuRecord.includes(:benchmark_values).orderByParms('batch_execute_records.id desc',params).paginate( :page=>params[:page], :per_page => 20).find(:all, :order => 'benchmark_values.date')
        @local_cpu_records.each do |lcr|
          bvalue = lcr.benchmark_values.select { |a| a.date.to_date < lcr.recordDate.to_date }.last
          @bvalues_hash[lcr.id] = bvalue.value if bvalue
        end
      }
      format.any(:xml,:json) {
        @local_cpu_records = LocalCpuRecord.all
      }
    end
    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @local_cpu_records }
      format.xml { render :xml => @local_cpu_records }
    end
  end
  
  # GET /local_cpu_records/stats
  # GET /local_cpu_records/stats.json
  def stats
    @stats = {}
    @stats[:records_count]= LocalCpuRecord.count
    @stats[:earliest_record]= LocalCpuRecord.minimum(:recordDate)
    @stats[:latest_record]= LocalCpuRecord.maximum(:recordDate)
    @stats[:records_cpu_sum]= LocalCpuRecord.sum(:resourceUsed_cput)/86400
    startFrom = "2007-04-06".to_date
    if @stats[:latest_record]
      startFrom = @stats[:latest_record].to_date-90 
    end
    #GRAPH for latest 3 months.
    @results1 = LocalCpuRecord.select("date(recordDate) as ordered_date , count(*) as count, sum(resourceUsed_walltime)/3600 as wall, sum(resourceUsed_cput)/3600 as cpu").where("recordDate > ?",startFrom).group("ordered_date")
    table = GoogleVisualr::DataTable.new
    
    
    # Add Column Headers
    table.new_column('date', 'Date' )
    table.new_column('number', 'jobs')
    table.new_column('number', 'wall time (h)')
    table.new_column('number', 'cpu time (h)')
    
    
    @results1.each do |result1|
      table.add_row([result1.ordered_date.to_date,result1.count.to_i,result1.wall.to_i,result1.cpu.to_i])
    end 
    
    
    option1 = { :width => 1200, :height => 600, :title => 'Local Jobs' }
    @chart1 = GoogleVisualr::Interactive::AreaChart.new(table, option1)

    

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @stats }
      format.xml { render :xml => @stats }
    end
  end
  

  # GET /local_cpu_records/1
  # GET /local_cpu_records/1.json
  # GET /local_cpu_records/1.xml
  def show
    @local_cpu_record = LocalCpuRecord.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @local_cpu_record }
      format.xml { render :xml => @local_cpu_record }
    end
  end

  # GET /local_cpu_records/new
  # GET /local_cpu_records/new.json
  #GET /local_cpu_records/new.xml
  def new
    @local_cpu_record = LocalCpuRecord.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @local_cpu_record }
      format.xml { render :xml => @local_cpu_record }
    end
  end

  # GET /local_cpu_records/1/edit
  def edit
    @local_cpu_record = LocalCpuRecord.find(params[:id])
  end

  # POST /local_cpu_records
  # POST /local_cpu_records.json
  # POST /local_cpu_records.xml
  def create
    @local_cpu_record = LocalCpuRecord.new(params[:local_cpu_record])

    respond_to do |format|
      if @local_cpu_record.save
        format.html { redirect_to @local_cpu_record, :notice => 'Local cpu record was successfully created.' }
        format.json { render :json => @local_cpu_record, :status => :created, :location => @local_cpu_record }
        format.xml { render :xml => @local_cpu_record, :status => :created, :location => @local_cpu_record }
      else
        format.html { render :action => "new" }
        format.json { render :json => @local_cpu_record.errors, :status => :unprocessable_entity }
        format.xml { render :xml => @local_cpu_record.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /local_cpu_records/1
  # PUT /local_cpu_records/1.json
  # PUT /local_cpu_records/1.xml
  def update
    @local_cpu_record = LocalCpuRecord.find(params[:id])

    respond_to do |format|
      if @local_cpu_record.update_attributes(params[:local_cpu_record])
        format.html { redirect_to @local_cpu_record, :notice => 'Local cpu record was successfully updated.' }
        format.json { head :no_content }
        format.xml { head :no_content }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @local_cpu_record.errors, :status => :unprocessable_entity }
        format.xml { render :xml => @local_cpu_record.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /local_cpu_records/1
  # DELETE /local_cpu_records/1.json
  # DELETE /local_cpu_records/1.xml
  def destroy
    @local_cpu_record = LocalCpuRecord.find(params[:id])
    @local_cpu_record.destroy

    respond_to do |format|
      format.html { redirect_to local_cpu_records_url }
      format.json { head :no_content }
      format.xml { head :no_content }
    end
  end
end

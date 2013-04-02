class EmiComputeAccountingRecordsController < ApplicationController
  skip_before_filter :userAuthenticate
  skip_before_filter :publisherAuthenticate, :only => [:stats]
  # GET /emi_compute_accounting_records
  # GET /emi_compute_accounting_records.json
  def index
    @emi_compute_accounting_records = EmiComputeAccountingRecord.paginate :page=>params[:page], :order=>'id desc', :per_page => 25

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @emi_compute_accounting_records }
      format.xml { render :xml => @emi_compute_accounting_records }
    end
  end
  
  # GET /emi_compute_accounting_records/stats
  # GET /emi_compute_accounting_records/stats.json
  def stats
    @stats = {}
    @stats[:records_count]= EmiComputeAccountingRecord.count
    @stats[:records_cpu_sum] = EmiComputeAccountingRecord.sum(:cpuDuration)
    @stats[:records_cpu_avg] = EmiComputeAccountingRecord.average(:cpuDuration)
    @stats[:earliest_record] = EmiComputeAccountingRecord.minimum(:endTime)
    @stats[:latest_record] = EmiComputeAccountingRecord.maximum(:endTime)
    
    @results1 = EmiComputeAccountingRecord.select("date(endTime) as ordered_date, count(id) as count, sum(wallDuration)/864000 as sum_wall").group("date(endTime)")
    #@results2 = CloudRecord.select("date(startTime) as ordered_date, count(id) as count, sum(wallDuration)/864000 as sum_wall").group("date(startTime)")

    table = GoogleVisualr::DataTable.new
    table2 = GoogleVisualr::DataTable.new
    #table3 = GoogleVisualr::DataTable.new
    #table4 = GoogleVisualr::DataTable.new
    
    # Add Column Headers
    table.new_column('date', 'Date' )
    table.new_column('number', 'count')
    
    table2.new_column('date', 'Date' )
    table2.new_column('number', 'sum_wall')
    
    #table3.new_column('string', 'Date' )
    #table3.new_column('number', 'count')
    
    #table4.new_column('string', 'Date' )
    #table4.new_column('number', 'sum_wall')
    
    @results1.each do |result1|
      table.add_row([result1.ordered_date.to_date,result1.count.to_i])
      table2.add_row([result1.ordered_date.to_date,result1.sum_wall.to_i])
    end 
    
    #@results2.slice!(-1)
    #@results2.each do |result2|
    #  table3.add_row([result2.ordered_date,result2.count.to_i])
    #  table4.add_row([result2.ordered_date,result2.sum_wall.to_i])
    #end 
    
    
    option1 = { :width => 600, :height => 300, :title => 'Ended Jobs' }
    @chart1 = GoogleVisualr::Interactive::AreaChart.new(table, option1)
    
    option2 = { :width => 600, :height => 300, :title => 'Wall time' }
    @chart2 = GoogleVisualr::Interactive::AreaChart.new(table2, option2)

    ##option3 = { :width => 600, :height => 300, :title => 'Started VMs' }
    #@chart3 = GoogleVisualr::Interactive::AreaChart.new(table3, option3)
    
    #option4 = { :width => 600, :height => 300, :title => 'Wall time' }
    #@chart4 = GoogleVisualr::Interactive::AreaChart.new(table4, option4)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @stats }
      format.xml { render :xml => @stats }
    end
  end

  # GET /emi_compute_accounting_records/1
  # GET /emi_compute_accounting_records/1.json
  def show
    @emi_compute_accounting_record = EmiComputeAccountingRecord.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @emi_compute_accounting_record }
      format.xml { render :xml => @emi_compute_accounting_record }
    end
  end
  
  # GET /emi_compute_accounting_records/search?recordId=string
  def search
    @emi_compute_accounting_record = EmiComputeAccoutningRecord.find_by_recordId(params[:recordId])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @emi_compute_accounting_record.to_json(:include => { :site => {:only => :name} , :resource => {:only => :name} } ) }
      format.xml { render :xml => @emi_compute_accoutnting_record.to_xml(:include => { :site => {:only => :name} , :resource => {:only => :name} } )}
    end
  end

  # GET /emi_compute_accounting_records/new
  # GET /emi_compute_accounting_records/new.json
  def new
    @emi_compute_accounting_record = EmiComputeAccountingRecord.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @emi_compute_accounting_record }
    end
  end

  # GET /emi_compute_accounting_records/1/edit
  def edit
    @emi_compute_accounting_record = EmiComputeAccountingRecord.find(params[:id])
  end

  # POST /emi_compute_accounting_records
  # POST /emi_compute_accounting_records.json
  def create
    @emi_compute_accounting_record = EmiComputeAccountingRecord.new(params[:emi_compute_accounting_record])

    respond_to do |format|
      if @emi_compute_accounting_record.save
        format.html { redirect_to @emi_compute_accounting_record, :notice => 'Emi compute accounting record was successfully created.' }
        format.json { render :json => @emi_compute_accounting_record, :status => :created, :location => @emi_compute_accounting_record }
        format.xml { render :xml => @emi_compute_accounting_record, :status => :created, :location => @emi_compute_accounting_record }
      else
        format.html { render :action => "new" }
        format.json { render :json => @emi_compute_accounting_record.errors, :status => :unprocessable_entity }
        format.xml { render :xml => @emi_compute_accounting_record.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /emi_compute_accounting_records/1
  # PUT /emi_compute_accounting_records/1.json
  def update
    @emi_compute_accounting_record = EmiComputeAccountingRecord.find(params[:id])
    skipMassAssign :emi_compute_accounting_record
    respond_to do |format|
      if @emi_compute_accounting_record.update_attributes(params[:emi_compute_accounting_record])
        format.html { redirect_to @emi_compute_accounting_record, :notice => 'Emi compute accounting record was successfully updated.' }
        format.json { head :no_content }
        format.xml { head :no_content }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @emi_compute_accounting_record.errors, :status => :unprocessable_entity }
        format.xml { render :xml => @emi_compute_accounting_record.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /emi_compute_accounting_records/1
  # DELETE /emi_compute_accounting_records/1.json
  def destroy
    @emi_compute_accounting_record = EmiComputeAccountingRecord.find(params[:id])
    @emi_compute_accounting_record.destroy

    respond_to do |format|
      format.html { redirect_to emi_compute_accounting_records_url }
      format.json { head :no_content }
      format.xml { head :no_content }
    end
  end
end

class EmiStorageRecordsController < ApplicationController
  skip_before_filter :userAuthenticate
  # GET /emi_storage_records
  # GET /emi_storage_records.json
  def index
    @emi_storage_records = EmiStorageRecord.orderByParms('id desc',params).paginate :page=>params[:page], :per_page => config.itemsPerPageHTML

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @emi_storage_records }
      format.xml { render :xml => @emi_storage_records }
    end
  end
  
   # GET /emi_storage_records/stats
  # GET /emi_storage_records/stats.json
  def stats
    @stats = {}
    @stats[:records_count]= EmiStorageRecord.count
    @stats[:earliest_record]= EmiStorageRecord.minimum(:endTime)
    @stats[:latest_record]= EmiStorageRecord.maximum(:endTime)
    @stats[:records_storage_sum]= EmiStorageRecord.sum(:resourceCapacityUsed)/1024000000
    startFrom = "2007-04-06".to_date
    if @stats[:latest_record]
      startFrom = @stats[:latest_record].to_date-90 
    end
    #GRAPH for latest 3 months.
    @results1 = EmiStorageRecord.select("date(endTime) as ordered_date, count(*) as count, sum(resourceCapacityUsed)/1048576000000 as used").group("date(endTime)").order("ordered_date")
    table = GoogleVisualr::DataTable.new
    
    
    # Add Column Headers
    table.new_column('date', 'Date' )
    table.new_column('number', 'records')
    table.new_column('number', 'storage consumed (PB)')
    
    
    @results1.each do |result1|
      table.add_row([result1.ordered_date.to_date,result1.count.to_i,result1.used.to_i])
    end 
    
    
    option1 = { :width => 1200, :height => 600, :title => 'Storage records' }
    @chart1 = GoogleVisualr::Interactive::AreaChart.new(table, option1)

    

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @stats }
      format.xml { render :xml => @stats }
    end
  end

  # GET /emi_storage_records/1
  # GET /emi_storage_records/1.json
  def show
    @emi_storage_record = EmiStorageRecord.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @emi_storage_record }
      format.xml { render :xml => @emi_storage_record }
    end
  end

  # GET /emi_storage_records/new
  # GET /emi_storage_records/new.json
  def new
    @emi_storage_record = EmiStorageRecord.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @emi_storage_record }
      format.xml { render :xml => @emi_storage_record }
    end
  end

  # GET /emi_storage_records/1/edit
  def edit
    @emi_storage_record = EmiStorageRecord.find(params[:id])
  end

  # POST /emi_storage_records
  # POST /emi_storage_records.json
  def create
    @emi_storage_record = EmiStorageRecord.new(params[:emi_storage_record])
    @emi_storage_record.publisher = Publisher.find_by_token(session[:token])
    logger.info "Received API-KEY:#{session[:token]}, which maps to :#{@emi_storage_record.publisher.hostname}"

    respond_to do |format|
      if @emi_storage_record.save
        format.html { redirect_to @emi_storage_record, :notice => 'Emi storage record was successfully created.' }
        format.json { render :json => @emi_storage_record, :status => :created, :location => @emi_storage_record }
        format.xml { render :xml => @emi_storage_record, :status => :created, :location => @emi_storage_record }
      else
        format.html { render :action => "new" }
        format.json { render :json => @emi_storage_record.errors, :status => :unprocessable_entity }
        format.xml { render :xml=> @emi_storage_record.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /emi_storage_records/1
  # PUT /emi_storage_records/1.json
  def update
    @emi_storage_record = EmiStorageRecord.find(params[:id])

    respond_to do |format|
      if @emi_storage_record.update_attributes(params[:emi_storage_record])
        format.html { redirect_to @emi_storage_record, :notice => 'Emi storage record was successfully updated.' }
        format.json { head :no_content }
        format.xml { head :no_content }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @emi_storage_record.errors, :status => :unprocessable_entity }
        format.xml { render :xml => @emi_storage_record.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /emi_storage_records/1
  # DELETE /emi_storage_records/1.json
  def destroy
    @emi_storage_record = EmiStorageRecord.find(params[:id])
    @emi_storage_record.destroy

    respond_to do |format|
      format.html { redirect_to emi_storage_records_url }
      format.json { head :no_content }
      format.xml { head :no_content }
    end
  end
end

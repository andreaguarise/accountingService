class CloudRecordsController < ApplicationController
  skip_before_filter :userAuthenticate
  skip_before_filter :publisherAuthenticate, :only => [:stats]
  # GET /cloud_records
  # GET /cloud_records.json
  # GET /cloud_records.xml
  def index
    respond_to do |format|
      format.html {
        @cloud_records = CloudRecord.paginate(:page=>params[:page], :per_page => 25).orderByParms('id desc',params)
      }
      format.any(:xml,:json){
        @cloud_records = CloudRecord.all
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
    @stats[:earliest_record] = CloudRecord.minimum(:endTime)
    @stats[:latest_record] = CloudRecord.maximum(:endTime)
    @stats[:sum_wall] = CloudRecord.sum(:wallDuration)

    data_table = GoogleVisualr::DataTable.new
    # Add Column Headers
    data_table.new_column('date', 'date' )
    data_table.new_column('number', 'started')
    data_table.new_column('number', 'started-ended')
    data_table.new_column('number', 'running')

    # Add Rows and Values

    partial = {}
    running = {}
    incremental = 0

    started_ary = CloudRecord.group('date(startTime)').count
    ended_ary = CloudRecord.group('date(endTime)').count

    started_ary.each do |date,startedCount|
      if ended_ary[date]
      partial[date] = startedCount-ended_ary[date]
      else
      partial[date] = startedCount
      end
      incremental = incremental + partial[date]
      running[date] = incremental
      #puts "date:#{date}, running:#{running[date]}  --->  partial: #{partial[date]}"
      data_table.add_row([date.to_date,startedCount,partial[date],running[date]])
    end
    
    option = { :width => 1100, :height => 650, :title => 'Running VMs' }
    @chart = GoogleVisualr::Interactive::AreaChart.new(data_table, option)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @stats }
      format.xml { render :xml => @stats }
    end
  end

  # GET /cloud_record/search?VMUUID=string
  def search
    @cloud_record = CloudRecord.find_by_VMUUID(params[:VMUUID])

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

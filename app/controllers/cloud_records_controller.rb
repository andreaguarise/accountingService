class CloudRecordsController < ApplicationController
  skip_before_filter :userAuthenticate
  skip_before_filter :publisherAuthenticate, :only => [:stats]
  # GET /cloud_records
  # GET /cloud_records.json
  # GET /cloud_records.xml
  def index
    @cloud_records = CloudRecord.paginate :page=>params[:page], :order=>'id desc', :per_page => 25

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
    

    @results1 = CloudRecord.select("date(endTime) as ordered_date, count(id) as count, sum(wallDuration)/864000 as sum_wall").group("date(endTime)")
    @results2 = CloudRecord.select("date(startTime) as ordered_date, count(id) as count, sum(wallDuration)/864000 as sum_wall").group("date(startTime)")

    table = GoogleVisualr::DataTable.new
    table2 = GoogleVisualr::DataTable.new
    table3 = GoogleVisualr::DataTable.new
    table4 = GoogleVisualr::DataTable.new
    
    # Add Column Headers
    table.new_column('date', 'Date' )
    table.new_column('number', 'count')
    
    table2.new_column('date', 'Date' )
    table2.new_column('number', 'sum_wall')
    
    table3.new_column('date', 'Date' )
    table3.new_column('number', 'count')
    
    table4.new_column('date', 'Date' )
    table4.new_column('number', 'sum_wall')
    
    @results1.slice!(-1)
    @results1.each do |result1|
      table.add_row([result1.ordered_date.to_date,result1.count.to_i])
      table2.add_row([result1.ordered_date.to_date,result1.sum_wall.to_i])
    end 
    
    @results2.slice!(-1)
    @results2.each do |result2|
      table3.add_row([result2.ordered_date.to_date,result2.count.to_i])
      table4.add_row([result2.ordered_date.to_date,result2.sum_wall.to_i])
    end 
    
    
    option1 = { :width => 600, :height => 300, :title => 'Ended VMs' }
    @chart1 = GoogleVisualr::Interactive::AreaChart.new(table, option1)
    
    option2 = { :width => 600, :height => 300, :title => 'Wall time' }
    @chart2 = GoogleVisualr::Interactive::AreaChart.new(table2, option2)

    option3 = { :width => 600, :height => 300, :title => 'Started VMs' }
    @chart3 = GoogleVisualr::Interactive::AreaChart.new(table3, option3)
    
    option4 = { :width => 600, :height => 300, :title => 'Wall time' }
    @chart4 = GoogleVisualr::Interactive::AreaChart.new(table4, option4)

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
    #if (params[:resource_name]) #HTML form
    #  @cloud_record.resource = Resource.find_by_name(params[:resource_name])
    #end

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

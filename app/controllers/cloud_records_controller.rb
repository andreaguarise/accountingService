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
    
    @graphs ={}
    @graphs['aliasByNode(sumSeries(summarize(faust.cpu_cloud_records.by_site.*.by_status.RUNNING.by_group.*.by_user.*.vmCount,"1d","avg")),10)'] = "&from=-90days"

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @stats }
      format.xml { render :xml => @stats }
    end
  end

  # GET /cloud_records/search?VMUUID=string
  def search
    whereBuffer = {}
    logger.info "Entering #search method."
    
    params.each do |param_k,param_v|
      if CloudRecord.attrSearchable.include?(param_k) && param_v != ""
        logger.info "Got search parameter: #{param_k} ==> #{param_v}" 
        whereBuffer[param_k]=param_v 
      end
   end
    
    @cloud_records = CloudRecord.joins(:publisher,:resource,:site).orderByParms('cloud_records.id desc',params).where(whereBuffer).paginate(:page=>params[:page], :per_page => config.itemsPerPageHTML).all 
    
    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @cloud_records.to_json(:include => { :site => {:only => :name} , :resource => {:only => :name} } ) }
      format.xml { render :xml => @cloud_records.to_xml(:include => { :site => {:only => :name} , :resource => {:only => :name} } )}
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

    if @cloud_record.cpuDuration > (@cloud_record.wallDuration*@cloud_record.cpuCount)
      logger.info "Got unbelievable cpuDuration of #{@cloud_record.cpuDuration}. Set it to ZERO. Sorry, not my fault..."
      @cloud_record.cpuDuration = 0
    end
    
    respond_to do |format|
      if CloudRecord.terminal_state.include?(@cloud_record.status) && (CloudRecord.where(:status => @cloud_record.status, :VMUUID => @cloud_record.VMUUID).count > 0)
         #Vm terminal state
         logger.info "Got record for terminal state."
           logger.info "record already found in db. Ignoring"
           format.html { redirect_to @cloud_record, :notice => 'Cloud record was successfully created.' }
           format.json { render :json => @cloud_record, :status => :created, :location => @cloud_record }
           format.xml { render :xml => @cloud_record, :status => :created, :location => @cloud_record }
      else 
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

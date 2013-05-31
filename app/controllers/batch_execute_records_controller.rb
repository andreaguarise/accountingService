class BatchExecuteRecordsController < ApplicationController
  skip_before_filter :userAuthenticate
  # GET /batch_execute_records
  # GET /batch_execute_records.json
  def index
    respond_to do |format|
      format.html {
        @bvalues_hash = {}
        #@batch_execute_records = BatchExecuteRecord.paginate :page=>params[:page], :order=>'id desc', :per_page => 20
        #this snippet associates each BatchExecuteRecord to is own benchmark_value on the bais of the date, taking the nearest 
        #(respect to recordDate) benchmark_values.value found in the benchmark_values table. association is done thrugh the publisher_id.
        #note that the limitation of the current implementation is that just one benchmark type per publisher would actually work. FIXME for this
        #limitation is needed.
        @batch_execute_records = BatchExecuteRecord.includes(:benchmark_values).paginate( :page=>params[:page], :order=>'batch_execute_records.id desc', :per_page => 20).find(:all, :order => 'benchmark_values.date')
        @batch_execute_records.each do |ber|
          bvalue = ber.benchmark_values.select { |a| a.date.to_date < ber.recordDate.to_date }.last
          @bvalues_hash[ber.id] = bvalue.value if bvalue
        end 
      }
      format.any(:xml,:json) {
        @batch_execute_records = BatchExecuteRecord.all 
      }
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @batch_execute_records }
      format.xml { render :xml => @batch_execute_records }
    end
  end
  
  # GET /batch_execute_records/search?lrmsId=string&start=string
  # GET /batch_execute_records/search?first=true
  # GET /batch_execute_records/search?last=true
  def search
      @batch_execute_record = BatchExecuteRecord.find_by_lrmsId_and_start(params[:lrmsId],params[:start]) if params[:lrmsId]
      @batch_execute_record = BatchExecuteRecord.last if params[:last]
      @batch_execute_record = BatchExecuteRecord.first if params[:first]

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @batch_execute_record.to_json(:include => { :site => {:only => :name} , :resource => {:only => :name} } ) }
      format.xml { render :xml => @batch_execute_record.to_xml(:include => { :site => {:only => :name} , :resource => {:only => :name} } )}
    end
  end
  

  # GET /batch_execute_records/1
  # GET /batch_execute_records/1.json
  def show
    @batch_execute_record = BatchExecuteRecord.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @batch_execute_record }
      format.xml { render :xml => @batch_execute_record }
    end
  end

  # GET /batch_execute_records/new
  # GET /batch_execute_records/new.json
  def new
    @batch_execute_record = BatchExecuteRecord.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @batch_execute_record }
      format.xml { render :xml => @batch_execute_record }
    end
  end

  # GET /batch_execute_records/1/edit
  def edit
    @batch_execute_record = BatchExecuteRecord.find(params[:id])
  end

  # POST /batch_execute_records
  # POST /batch_execute_records.json
  def create
    @batch_execute_record = BatchExecuteRecord.new(params[:batch_execute_record])
    @batch_execute_record.publisher = Publisher.find_by_token(session[:token])
    logger.info "Received API-KEY:#{session[:token]}, which maps to :#{@batch_execute_record.publisher.hostname}"

    respond_to do |format|
      if @batch_execute_record.save
        format.html { redirect_to @batch_execute_record, :notice => 'Batch execute record was successfully created.' }
        format.json { render :json => @batch_execute_record, :status => :created, :location => @batch_execute_record }
        format.xml { render :xml => @batch_execute_record, :status => :created, :location => @batch_execute_record }
      else
        format.html { render :action => "new" }
        format.json { render :json => @batch_execute_record.errors, :status => :unprocessable_entity }
        format.xml { render :xml => @batch_execute_record.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /batch_execute_records/1
  # PUT /batch_execute_records/1.json
  def update
    
    
    @batch_execute_record = BatchExecuteRecord.find(params[:id])
    skipMassAssign :batch_execute_record
    if params[:batch_execute_record][:resource]
      params[:batch_execute_record].delete(:resource)
    end

    respond_to do |format|
      if @batch_execute_record.update_attributes(params[:batch_execute_record])
        format.html { redirect_to @batch_execute_record, :notice => 'Batch execute record was successfully updated.' }
        format.json { head :no_content }
        format.xml { head :no_content }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @batch_execute_record.errors, :status => :unprocessable_entity }
        format.xml { render :xml => @batch_execute_record.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /batch_execute_records/1
  # DELETE /batch_execute_records/1.json
  def destroy
    @batch_execute_record = BatchExecuteRecord.find(params[:id])
    @batch_execute_record.destroy

    respond_to do |format|
      format.html { redirect_to batch_execute_records_url }
      format.json { head :no_content }
      format.xml { head :no_content }
    end
  end
end

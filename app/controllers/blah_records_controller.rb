class BlahRecordsController < ApplicationController
  skip_before_filter :userAuthenticate
  # GET /blah_records
  # GET /blah_records.json
  def index
    respond_to do |format|
      format.html {
        @blah_records = BlahRecord.paginate(:page=>params[:page],:per_page => config.itemsPerPageHTML).orderByParms('id desc',params)
      }
      format.any(:xml,:json){
        @blah_records = BlahRecord.paginate( :page=>params[:page], :per_page => config.itemsPerPage).all
      }
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @blah_records }
      format.xml { render :xml => @blah_records }
    end
  end

  # GET /blah_records/1
  # GET /blah_records/1.json
  def show
    @blah_record = BlahRecord.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @blah_record }
      format.xml { render :xml => @blah_record }
    end
  end
  
  
  # GET /blah_records/search?lrmsId=string&recordDate=string
  # GET /blah_records/search?first=true
  # GET /blah_records/search?last=true
  def search
      @blah_record = BlahRecord.find_by_lrmsId_and_recordDate(params[:lrmsId],params[:recordDate].to_time) if params[:lrmsId]
      @blah_record = BlahRecord.last if params[:last]
      @blah_record = BlahRecord.first if params[:first]

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @blah_record.to_json(:include => { :site => {:only => :name} , :resource => {:only => :name} } ) }
      format.xml { render :xml => @blah_record.to_xml(:include => { :site => {:only => :name} , :resource => {:only => :name} } )}
    end
  end

  # GET /blah_records/new
  # GET /blah_records/new.json
  def new
    @blah_record = BlahRecord.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @blah_record }
      format.xml { render :xml => @blah_record }
    end
  end

  # GET /blah_records/1/edit
  def edit
    @blah_record = BlahRecord.find(params[:id])
  end

  # POST /blah_records
  # POST /blah_records.json
  def create
    @blah_record = BlahRecord.new(params[:blah_record])
    @blah_record.publisher = Publisher.find_by_token(session[:token])
    logger.info "Received API-KEY:#{session[:token]}, which maps to :#{@blah_record.publisher.hostname}"

    respond_to do |format|
      if @blah_record.save
        format.html { redirect_to @blah_record, :notice => 'Blah record was successfully created.' }
        format.json { render :json => @blah_record, :status => :created, :location => @blah_record }
        format.xml { render :xml => @blah_record, :status => :created, :location => @blah_record }
      else
        format.html { render :action => "new" }
        format.json { render :json => @blah_record.errors, :status => :unprocessable_entity }
        format.xml { render :xml => @blah_record.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /blah_records/1
  # PUT /blah_records/1.json
  def update
    @blah_record = BlahRecord.find(params[:id])
    skipMassAssign :blah_record

    respond_to do |format|
      if @blah_record.update_attributes(params[:blah_record])
        format.html { redirect_to @blah_record, :notice => 'Blah record was successfully updated.' }
        format.json { head :no_content }
        format.xml { head :no_content }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @blah_record.errors, :status => :unprocessable_entity }
        format.xml { render :json => @blah_record.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /blah_records/1
  # DELETE /blah_records/1.json
  def destroy
    @blah_record = BlahRecord.find(params[:id])
    @blah_record.destroy

    respond_to do |format|
      format.html { redirect_to blah_records_url }
      format.json { head :no_content }
      format.xml { head :no_content }
    end
  end
end

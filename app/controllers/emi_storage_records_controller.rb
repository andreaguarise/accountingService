class EmiStorageRecordsController < ApplicationController
  skip_before_filter :userAuthenticate
  # GET /emi_storage_records
  # GET /emi_storage_records.json
  def index
    @emi_storage_records = EmiStorageRecord.paginate :page=>params[:page], :order=>'id desc', :per_page => 20

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @emi_storage_records }
      format.xml { render :xml => @emi_storage_records }
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

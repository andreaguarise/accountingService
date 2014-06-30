class ApelSsmRecordsController < ApplicationController
  # GET /apel_ssm_records
  # GET /apel_ssm_records.json
  def index
    @apel_ssm_records = ApelSsmRecord.paginate( :page=>params[:page], :per_page => config.itemsPerPage).all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @apel_ssm_records }
      format.xml { render :xml => @apel_ssm_records }
    end
  end

  # GET /apel_ssm_records/1
  # GET /apel_ssm_records/1.json
  def show
    @apel_ssm_record = ApelSsmRecord.paginate( :page=>params[:page], :per_page => config.itemsPerPage).find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @apel_ssm_record }
      format.xml { render :xml => @apel_ssm_record }
    end
  end

  # GET /apel_ssm_records/new
  # GET /apel_ssm_records/new.json
  def new
    @apel_ssm_record = ApelSsmRecord.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @apel_ssm_record }
      format.xml { render :xml => @apel_ssm_record }
    end
  end

  # GET /apel_ssm_records/1/edit
  def edit
    @apel_ssm_record = ApelSsmRecord.find(params[:id])
  end

  # POST /apel_ssm_records
  # POST /apel_ssm_records.json
  def create
    @apel_ssm_record = ApelSsmRecord.new(params[:apel_ssm_record])

    respond_to do |format|
      if @apel_ssm_record.save
        format.html { redirect_to @apel_ssm_record, :notice => 'Apel ssm record was successfully created.' }
        format.json { render :json => @apel_ssm_record, :status => :created, :location => @apel_ssm_record }
        format.xml { render :xml => @apel_ssm_record, :status => :created, :location => @apel_ssm_record }
      else
        format.html { render :action => "new" }
        format.json { render :json => @apel_ssm_record.errors, :status => :unprocessable_entity }
        format.xml { render :xml => @apel_ssm_record.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /apel_ssm_records/1
  # PUT /apel_ssm_records/1.json
  def update
    @apel_ssm_record = ApelSsmRecord.find(params[:id])

    respond_to do |format|
      if @apel_ssm_record.update_attributes(params[:apel_ssm_record])
        format.html { redirect_to @apel_ssm_record, :notice => 'Apel ssm record was successfully updated.' }
        format.json { head :no_content }
        format.xml { head :no_content }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @apel_ssm_record.errors, :status => :unprocessable_entity }
        format.xml { render :xml => @apel_ssm_record.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /apel_ssm_records/1
  # DELETE /apel_ssm_records/1.json
  def destroy
    @apel_ssm_record = ApelSsmRecord.find(params[:id])
    @apel_ssm_record.destroy

    respond_to do |format|
      format.html { redirect_to apel_ssm_records_url }
      format.json { head :no_content }
      format.xml { head :no_content }
    end
  end
end

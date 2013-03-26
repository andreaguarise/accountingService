class EmiComputeAccountingRecordsController < ApplicationController
  skip_before_filter :userAuthenticate
  skip_before_filter :publisherAuthenticate, :only => [:stats]
  # GET /emi_compute_accounting_records
  # GET /emi_compute_accounting_records.json
  def index
    @emi_compute_accounting_records = EmiComputeAccountingRecord.all

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

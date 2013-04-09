class TorqueDispatchRecordsController < ApplicationController
  skip_before_filter :userAuthenticate
  # GET /torque_dispatch_records
  # GET /torque_dispatch_records.json
  def index
    @torque_dispatch_records = TorqueDispatchRecord.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @torque_dispatch_records }
    end
  end

  # GET /torque_dispatch_records/1
  # GET /torque_dispatch_records/1.json
  def show
    @torque_dispatch_record = TorqueDispatchRecord.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @torque_dispatch_record }
    end
  end

  # GET /torque_dispatch_records/new
  # GET /torque_dispatch_records/new.json
  def new
    @torque_dispatch_record = TorqueDispatchRecord.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @torque_dispatch_record }
    end
  end

  # GET /torque_dispatch_records/1/edit
  def edit
    @torque_dispatch_record = TorqueDispatchRecord.find(params[:id])
  end

  # POST /torque_dispatch_records
  # POST /torque_dispatch_records.json
  def create
    @torque_dispatch_record = TorqueDispatchRecord.new(params[:torque_dispatch_record])

    respond_to do |format|
      if @torque_dispatch_record.save
        format.html { redirect_to @torque_dispatch_record, :notice => 'Torque dispatch record was successfully created.' }
        format.json { render :json => @torque_dispatch_record, :status => :created, :location => @torque_dispatch_record }
      else
        format.html { render :action => "new" }
        format.json { render :json => @torque_dispatch_record.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /torque_dispatch_records/1
  # PUT /torque_dispatch_records/1.json
  def update
    @torque_dispatch_record = TorqueDispatchRecord.find(params[:id])

    respond_to do |format|
      if @torque_dispatch_record.update_attributes(params[:torque_dispatch_record])
        format.html { redirect_to @torque_dispatch_record, :notice => 'Torque dispatch record was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @torque_dispatch_record.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /torque_dispatch_records/1
  # DELETE /torque_dispatch_records/1.json
  def destroy
    @torque_dispatch_record = TorqueDispatchRecord.find(params[:id])
    @torque_dispatch_record.destroy

    respond_to do |format|
      format.html { redirect_to torque_dispatch_records_url }
      format.json { head :no_content }
    end
  end
end

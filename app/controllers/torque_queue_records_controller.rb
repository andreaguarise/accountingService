class TorqueQueueRecordsController < ApplicationController
  # GET /torque_queue_records
  # GET /torque_queue_records.json
  def index
    @torque_queue_records = TorqueQueueRecord.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @torque_queue_records }
    end
  end

  # GET /torque_queue_records/1
  # GET /torque_queue_records/1.json
  def show
    @torque_queue_record = TorqueQueueRecord.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @torque_queue_record }
    end
  end

  # GET /torque_queue_records/new
  # GET /torque_queue_records/new.json
  def new
    @torque_queue_record = TorqueQueueRecord.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @torque_queue_record }
    end
  end

  # GET /torque_queue_records/1/edit
  def edit
    @torque_queue_record = TorqueQueueRecord.find(params[:id])
  end

  # POST /torque_queue_records
  # POST /torque_queue_records.json
  def create
    @torque_queue_record = TorqueQueueRecord.new(params[:torque_queue_record])

    respond_to do |format|
      if @torque_queue_record.save
        format.html { redirect_to @torque_queue_record, :notice => 'Torque queue record was successfully created.' }
        format.json { render :json => @torque_queue_record, :status => :created, :location => @torque_queue_record }
      else
        format.html { render :action => "new" }
        format.json { render :json => @torque_queue_record.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /torque_queue_records/1
  # PUT /torque_queue_records/1.json
  def update
    @torque_queue_record = TorqueQueueRecord.find(params[:id])

    respond_to do |format|
      if @torque_queue_record.update_attributes(params[:torque_queue_record])
        format.html { redirect_to @torque_queue_record, :notice => 'Torque queue record was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @torque_queue_record.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /torque_queue_records/1
  # DELETE /torque_queue_records/1.json
  def destroy
    @torque_queue_record = TorqueQueueRecord.find(params[:id])
    @torque_queue_record.destroy

    respond_to do |format|
      format.html { redirect_to torque_queue_records_url }
      format.json { head :no_content }
    end
  end
end

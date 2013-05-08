class TorqueExecuteRecordsController < ApplicationController
  skip_before_filter :userAuthenticate
  # GET /torque_execute_records
  # GET /torque_execute_records.json
  def index
    @torque_execute_records = TorqueExecuteRecord.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @torque_execute_records }
      format.xml { render :xml => @torque_execute_records }
    end
  end

  # GET /torque_execute_records/1
  # GET /torque_execute_records/1.json
  def show
    @torque_execute_record = TorqueExecuteRecord.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @torque_execute_record }
      format.xml { render :xml => @torque_execute_record }
    end
  end

  # GET /torque_execute_records/new
  # GET /torque_execute_records/new.json
  def new
    @torque_execute_record = TorqueExecuteRecord.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @torque_execute_record }
      format.xml { render :xml => @torque_execute_record }
    end
  end

  # GET /torque_execute_records/1/edit
  def edit
    @torque_execute_record = TorqueExecuteRecord.find(params[:id])
  end

  # POST /torque_execute_records
  # POST /torque_execute_records.json
  def create
    @torque_execute_record = TorqueExecuteRecord.new(params[:torque_execute_record])
    @torque_execute_record.publisher = Publisher.find_by_token(session[:token])
    logger.info "Received API-KEY:#{session[:token]}, which maps to :#{@torque_execute_record.publisher.hostname}"

    respond_to do |format|
      if @torque_execute_record.save
        format.html { redirect_to @torque_execute_record, :notice => 'Torque execute record was successfully created.' }
        format.json { render :json => @torque_execute_record, :status => :created, :location => @torque_execute_record }
        format.xml { render :xml => @torque_execute_record, :status => :created, :location => @torque_execute_record }
      else
        format.html { render :action => "new" }
        format.json { render :json => @torque_execute_record.errors, :status => :unprocessable_entity }
        format.xml { render :xml => @torque_execute_record.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /torque_execute_records/1
  # PUT /torque_execute_records/1.json
  def update
    @torque_execute_record = TorqueExecuteRecord.find(params[:id])

    respond_to do |format|
      if @torque_execute_record.update_attributes(params[:torque_execute_record])
        format.html { redirect_to @torque_execute_record, :notice => 'Torque execute record was successfully updated.' }
        format.json { head :no_content }
        format.xml { head :no_content }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @torque_execute_record.errors, :status => :unprocessable_entity }
        format.xml { render :xml => @torque_execute_record.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /torque_execute_records/1
  # DELETE /torque_execute_records/1.json
  def destroy
    @torque_execute_record = TorqueExecuteRecord.find(params[:id])
    @torque_execute_record.destroy

    respond_to do |format|
      format.html { redirect_to torque_execute_records_url }
      format.json { head :no_content }
      format.xml { head :no_content }
    end
  end
end

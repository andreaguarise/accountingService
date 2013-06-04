class LocalCpuRecordsController < ApplicationController
  skip_before_filter :userAuthenticate
  # GET /local_cpu_records
  # GET /local_cpu_records.json
  def index
    @local_cpu_records = LocalCpuRecord.paginate :page=>params[:page], :order=>'id desc', :per_page => 20

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @local_cpu_records }
    end
  end

  # GET /local_cpu_records/1
  # GET /local_cpu_records/1.json
  def show
    @local_cpu_record = LocalCpuRecord.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @local_cpu_record }
    end
  end

  # GET /local_cpu_records/new
  # GET /local_cpu_records/new.json
  def new
    @local_cpu_record = LocalCpuRecord.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @local_cpu_record }
    end
  end

  # GET /local_cpu_records/1/edit
  def edit
    @local_cpu_record = LocalCpuRecord.find(params[:id])
  end

  # POST /local_cpu_records
  # POST /local_cpu_records.json
  def create
    @local_cpu_record = LocalCpuRecord.new(params[:local_cpu_record])

    respond_to do |format|
      if @local_cpu_record.save
        format.html { redirect_to @local_cpu_record, :notice => 'Local cpu record was successfully created.' }
        format.json { render :json => @local_cpu_record, :status => :created, :location => @local_cpu_record }
      else
        format.html { render :action => "new" }
        format.json { render :json => @local_cpu_record.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /local_cpu_records/1
  # PUT /local_cpu_records/1.json
  def update
    @local_cpu_record = LocalCpuRecord.find(params[:id])

    respond_to do |format|
      if @local_cpu_record.update_attributes(params[:local_cpu_record])
        format.html { redirect_to @local_cpu_record, :notice => 'Local cpu record was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @local_cpu_record.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /local_cpu_records/1
  # DELETE /local_cpu_records/1.json
  def destroy
    @local_cpu_record = LocalCpuRecord.find(params[:id])
    @local_cpu_record.destroy

    respond_to do |format|
      format.html { redirect_to local_cpu_records_url }
      format.json { head :no_content }
    end
  end
end
class DgasGridCpuRecordsController < ApplicationController
  # GET /dgas_grid_cpu_records
  # GET /dgas_grid_cpu_records.json
  def index
    @dgas_grid_cpu_records = DgasGridCpuRecord.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @dgas_grid_cpu_records }
    end
  end

  # GET /dgas_grid_cpu_records/1
  # GET /dgas_grid_cpu_records/1.json
  def show
    @dgas_grid_cpu_record = DgasGridCpuRecord.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @dgas_grid_cpu_record }
    end
  end

  # GET /dgas_grid_cpu_records/new
  # GET /dgas_grid_cpu_records/new.json
  def new
    @dgas_grid_cpu_record = DgasGridCpuRecord.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @dgas_grid_cpu_record }
    end
  end

  # GET /dgas_grid_cpu_records/1/edit
  def edit
    @dgas_grid_cpu_record = DgasGridCpuRecord.find(params[:id])
  end

  # POST /dgas_grid_cpu_records
  # POST /dgas_grid_cpu_records.json
  def create
    @dgas_grid_cpu_record = DgasGridCpuRecord.new(params[:dgas_grid_cpu_record])

    respond_to do |format|
      if @dgas_grid_cpu_record.save
        format.html { redirect_to @dgas_grid_cpu_record, :notice => 'Dgas grid cpu record was successfully created.' }
        format.json { render :json => @dgas_grid_cpu_record, :status => :created, :location => @dgas_grid_cpu_record }
      else
        format.html { render :action => "new" }
        format.json { render :json => @dgas_grid_cpu_record.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /dgas_grid_cpu_records/1
  # PUT /dgas_grid_cpu_records/1.json
  def update
    @dgas_grid_cpu_record = DgasGridCpuRecord.find(params[:id])

    respond_to do |format|
      if @dgas_grid_cpu_record.update_attributes(params[:dgas_grid_cpu_record])
        format.html { redirect_to @dgas_grid_cpu_record, :notice => 'Dgas grid cpu record was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @dgas_grid_cpu_record.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /dgas_grid_cpu_records/1
  # DELETE /dgas_grid_cpu_records/1.json
  def destroy
    @dgas_grid_cpu_record = DgasGridCpuRecord.find(params[:id])
    @dgas_grid_cpu_record.destroy

    respond_to do |format|
      format.html { redirect_to dgas_grid_cpu_records_url }
      format.json { head :no_content }
    end
  end
end

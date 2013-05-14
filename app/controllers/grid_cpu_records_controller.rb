class GridCpuRecordsController < ApplicationController
  skip_before_filter :userAuthenticate
  skip_before_filter :publisherAuthenticate, :only => [:stats]
  # GET /grid_cpu_records
  # GET /grid_cpu_records.json
  def index
    @grid_cpu_records = GridCpuRecord.paginate :page=>params[:page], :order=>'id desc', :per_page => 20

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @grid_cpu_records }
    end
  end

  # GET /grid_cpu_records/1
  # GET /grid_cpu_records/1.json
  def show
    @grid_cpu_record = GridCpuRecord.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @grid_cpu_record }
    end
  end

  # GET /grid_cpu_records/new
  # GET /grid_cpu_records/new.json
  def new
    @grid_cpu_record = GridCpuRecord.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @grid_cpu_record }
    end
  end

  # GET /grid_cpu_records/1/edit
  def edit
    @grid_cpu_record = GridCpuRecord.find(params[:id])
  end

  # POST /grid_cpu_records
  # POST /grid_cpu_records.json
  def create
    @grid_cpu_record = GridCpuRecord.new(params[:grid_cpu_record])

    respond_to do |format|
      if @grid_cpu_record.save
        format.html { redirect_to @grid_cpu_record, :notice => 'Grid cpu record was successfully created.' }
        format.json { render :json => @grid_cpu_record, :status => :created, :location => @grid_cpu_record }
      else
        format.html { render :action => "new" }
        format.json { render :json => @grid_cpu_record.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /grid_cpu_records/1
  # PUT /grid_cpu_records/1.json
  def update
    @grid_cpu_record = GridCpuRecord.find(params[:id])

    respond_to do |format|
      if @grid_cpu_record.update_attributes(params[:grid_cpu_record])
        format.html { redirect_to @grid_cpu_record, :notice => 'Grid cpu record was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @grid_cpu_record.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /grid_cpu_records/1
  # DELETE /grid_cpu_records/1.json
  def destroy
    @grid_cpu_record = GridCpuRecord.find(params[:id])
    @grid_cpu_record.destroy

    respond_to do |format|
      format.html { redirect_to grid_cpu_records_url }
      format.json { head :no_content }
    end
  end
end

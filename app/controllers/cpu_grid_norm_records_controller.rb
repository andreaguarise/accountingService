class CpuGridNormRecordsController < ApplicationController
  # GET /cpu_grid_norm_records
  # GET /cpu_grid_norm_records.json
  def index
    @cpu_grid_norm_records = CpuGridNormRecord.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @cpu_grid_norm_records }
    end
  end

  # GET /cpu_grid_norm_records/1
  # GET /cpu_grid_norm_records/1.json
  def show
    @cpu_grid_norm_record = CpuGridNormRecord.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @cpu_grid_norm_record }
    end
  end

  # GET /cpu_grid_norm_records/new
  # GET /cpu_grid_norm_records/new.json
  def new
    @cpu_grid_norm_record = CpuGridNormRecord.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @cpu_grid_norm_record }
    end
  end

  # GET /cpu_grid_norm_records/1/edit
  def edit
    @cpu_grid_norm_record = CpuGridNormRecord.find(params[:id])
  end

  # POST /cpu_grid_norm_records
  # POST /cpu_grid_norm_records.json
  def create
    @cpu_grid_norm_record = CpuGridNormRecord.new(params[:cpu_grid_norm_record])

    respond_to do |format|
      if @cpu_grid_norm_record.save
        format.html { redirect_to @cpu_grid_norm_record, :notice => 'Cpu grid norm record was successfully created.' }
        format.json { render :json => @cpu_grid_norm_record, :status => :created, :location => @cpu_grid_norm_record }
      else
        format.html { render :action => "new" }
        format.json { render :json => @cpu_grid_norm_record.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /cpu_grid_norm_records/1
  # PUT /cpu_grid_norm_records/1.json
  def update
    @cpu_grid_norm_record = CpuGridNormRecord.find(params[:id])

    respond_to do |format|
      if @cpu_grid_norm_record.update_attributes(params[:cpu_grid_norm_record])
        format.html { redirect_to @cpu_grid_norm_record, :notice => 'Cpu grid norm record was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @cpu_grid_norm_record.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /cpu_grid_norm_records/1
  # DELETE /cpu_grid_norm_records/1.json
  def destroy
    @cpu_grid_norm_record = CpuGridNormRecord.find(params[:id])
    @cpu_grid_norm_record.destroy

    respond_to do |format|
      format.html { redirect_to cpu_grid_norm_records_url }
      format.json { head :no_content }
    end
  end
end

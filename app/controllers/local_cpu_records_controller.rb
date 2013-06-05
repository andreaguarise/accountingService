class LocalCpuRecordsController < ApplicationController
  skip_before_filter :userAuthenticate
  # GET /local_cpu_records
  # GET /local_cpu_records.json
  # GET /local_cpu_records.xml
  def index
    respond_to do |format|
      format.html {
        @bvalues_hash = {}
        #@batch_execute_records = BatchExecuteRecord.paginate :page=>params[:page], :order=>'id desc', :per_page => 20
        #this snippet associates each BatchExecuteRecord to is own benchmark_value on the base of the date, taking the nearest
        #(respect to recordDate) benchmark_values.value found in the benchmark_values table. association is done thrugh the publisher_id.
        #note that the limitation of the current implementation is that just one benchmark type per publisher would actually work. FIXME for this
        #limitation is needed.
        @local_cpu_records = LocalCpuRecord.includes(:benchmark_values).paginate( :page=>params[:page], :order=>'batch_execute_records.id desc', :per_page => 20).find(:all, :order => 'benchmark_values.date')
        @local_cpu_records.each do |lcr|
          bvalue = lcr.benchmark_values.select { |a| a.date.to_date < lcr.recordDate.to_date }.last
          @bvalues_hash[lcr.id] = bvalue.value if bvalue
        end
      }
      format.any(:xml,:json) {
        @local_cpu_records = LocalCpuRecord.all
      }
    end
    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @local_cpu_records }
      format.xml { render :xml => @local_cpu_records }
    end
  end

  # GET /local_cpu_records/1
  # GET /local_cpu_records/1.json
  # GET /local_cpu_records/1.xml
  def show
    @local_cpu_record = LocalCpuRecord.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @local_cpu_record }
      format.xml { render :xml => @local_cpu_record }
    end
  end

  # GET /local_cpu_records/new
  # GET /local_cpu_records/new.json
  #GET /local_cpu_records/new.xml
  def new
    @local_cpu_record = LocalCpuRecord.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @local_cpu_record }
      format.xml { render :xml => @local_cpu_record }
    end
  end

  # GET /local_cpu_records/1/edit
  def edit
    @local_cpu_record = LocalCpuRecord.find(params[:id])
  end

  # POST /local_cpu_records
  # POST /local_cpu_records.json
  # POST /local_cpu_records.xml
  def create
    @local_cpu_record = LocalCpuRecord.new(params[:local_cpu_record])

    respond_to do |format|
      if @local_cpu_record.save
        format.html { redirect_to @local_cpu_record, :notice => 'Local cpu record was successfully created.' }
        format.json { render :json => @local_cpu_record, :status => :created, :location => @local_cpu_record }
        format.xml { render :xml => @local_cpu_record, :status => :created, :location => @local_cpu_record }
      else
        format.html { render :action => "new" }
        format.json { render :json => @local_cpu_record.errors, :status => :unprocessable_entity }
        format.xml { render :xml => @local_cpu_record.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /local_cpu_records/1
  # PUT /local_cpu_records/1.json
  # PUT /local_cpu_records/1.xml
  def update
    @local_cpu_record = LocalCpuRecord.find(params[:id])

    respond_to do |format|
      if @local_cpu_record.update_attributes(params[:local_cpu_record])
        format.html { redirect_to @local_cpu_record, :notice => 'Local cpu record was successfully updated.' }
        format.json { head :no_content }
        format.xml { head :no_content }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @local_cpu_record.errors, :status => :unprocessable_entity }
        format.xml { render :xml => @local_cpu_record.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /local_cpu_records/1
  # DELETE /local_cpu_records/1.json
  # DELETE /local_cpu_records/1.xml
  def destroy
    @local_cpu_record = LocalCpuRecord.find(params[:id])
    @local_cpu_record.destroy

    respond_to do |format|
      format.html { redirect_to local_cpu_records_url }
      format.json { head :no_content }
      format.xml { head :no_content }
    end
  end
end

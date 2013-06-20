class BenchmarkValuesController < ApplicationController
  skip_before_filter :userAuthenticate
  # GET /benchmark_values
  # GET /benchmark_values.json
  # GET /benchmark_values.xml
  def index
    respond_to do |format|
      format.html {
        @benchmark_values = BenchmarkValue.joins(:benchmark_type,:publisher).select(
          "benchmark_values.id as id, 
          date, 
          publishers.hostname as publishers_hostname, 
          benchmark_types.name as benchmark_types_name, 
          value").paginate( :page=>params[:page], :per_page => 20).orderByParms('id',params).search(params[:key],params[:search])
    }
    format.any(:xml,:json) {
        @benchmark_values = BenchmarkValue.search(params[:key],params[:search])
    }
    end
    
    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @benchmark_values }
      format.xml { render :xml => @benchmark_values }
    end
  end

  # GET /benchmark_values/1
  # GET /benchmark_values/1.json
  # GET /benchmark_values/1.xml
  def show
    @benchmark_value = BenchmarkValue.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @benchmark_value }
      format.xml { render :xml => @benchmark_value }
    end
  end

  # GET /benchmark_values/new
  # GET /benchmark_values/new.json
  def new
    @benchmark_value = BenchmarkValue.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @benchmark_value }
      format.xml { render :xml => @benchmark_value }
    end
  end

  # GET /benchmark_values/1/edit
  def edit
    @benchmark_value = BenchmarkValue.find(params[:id])
  end

  # POST /benchmark_values
  # POST /benchmark_values.json
  def create
    @benchmark_value = BenchmarkValue.new(params[:benchmark_value])

    respond_to do |format|
      if @benchmark_value.save
        format.html { redirect_to @benchmark_value, :notice => 'Benchmark value was successfully created.' }
        format.json { render :json => @benchmark_value, :status => :created, :location => @benchmark_value }
        format.xml { render :xml => @benchmark_value, :status => :created, :location => @benchmark_value }
      else
        format.html { render :action => "new" }
        format.json { render :json => @benchmark_value.errors, :status => :unprocessable_entity }
        format.xml { render :xml => @benchmark_value.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /benchmark_values/1
  # PUT /benchmark_values/1.json
  def update
    @benchmark_value = BenchmarkValue.find(params[:id])

    respond_to do |format|
      if @benchmark_value.update_attributes(params[:benchmark_value])
        format.html { redirect_to @benchmark_value, :notice => 'Benchmark value was successfully updated.' }
        format.json { head :no_content }
        format.xml { head :no_content }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @benchmark_value.errors, :status => :unprocessable_entity }
        format.xml { render :xml => @benchmark_value.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /benchmark_values/1
  # DELETE /benchmark_values/1.json
  def destroy
    @benchmark_value = BenchmarkValue.find(params[:id])
    @benchmark_value.destroy

    respond_to do |format|
      format.html { redirect_to benchmark_values_url }
      format.json { head :no_content }
      format.xml { head :no_content }
    end
  end
end

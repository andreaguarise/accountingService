class BenchmarkValuesController < ApplicationController
  skip_before_filter :userAuthenticate
  # GET /benchmark_values
  # GET /benchmark_values.json
  def index
    @benchmark_values = BenchmarkValue.paginate :page=>params[:page], :order=>'id desc', :per_page => 20

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @benchmark_values }
    end
  end

  # GET /benchmark_values/1
  # GET /benchmark_values/1.json
  def show
    @benchmark_value = BenchmarkValue.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @benchmark_value }
    end
  end

  # GET /benchmark_values/new
  # GET /benchmark_values/new.json
  def new
    @benchmark_value = BenchmarkValue.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @benchmark_value }
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
      else
        format.html { render :action => "new" }
        format.json { render :json => @benchmark_value.errors, :status => :unprocessable_entity }
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
      else
        format.html { render :action => "edit" }
        format.json { render :json => @benchmark_value.errors, :status => :unprocessable_entity }
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
    end
  end
end

class BenchmarkTypesController < ApplicationController
  skip_before_filter :userAuthenticate
  # GET /benchmark_types
  # GET /benchmark_types.json
  def index
    @benchmark_types = BenchmarkType.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @benchmark_types }
    end
  end

  # GET /benchmark_types/1
  # GET /benchmark_types/1.json
  def show
    @benchmark_type = BenchmarkType.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @benchmark_type }
    end
  end

  # GET /benchmark_types/new
  # GET /benchmark_types/new.json
  def new
    @benchmark_type = BenchmarkType.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @benchmark_type }
    end
  end

  # GET /benchmark_types/1/edit
  def edit
    @benchmark_type = BenchmarkType.find(params[:id])
  end

  # POST /benchmark_types
  # POST /benchmark_types.json
  def create
    @benchmark_type = BenchmarkType.new(params[:benchmark_type])

    respond_to do |format|
      if @benchmark_type.save
        format.html { redirect_to @benchmark_type, :notice => 'Benchmark type was successfully created.' }
        format.json { render :json => @benchmark_type, :status => :created, :location => @benchmark_type }
      else
        format.html { render :action => "new" }
        format.json { render :json => @benchmark_type.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /benchmark_types/1
  # PUT /benchmark_types/1.json
  def update
    @benchmark_type = BenchmarkType.find(params[:id])

    respond_to do |format|
      if @benchmark_type.update_attributes(params[:benchmark_type])
        format.html { redirect_to @benchmark_type, :notice => 'Benchmark type was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @benchmark_type.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /benchmark_types/1
  # DELETE /benchmark_types/1.json
  def destroy
    @benchmark_type = BenchmarkType.find(params[:id])
    @benchmark_type.destroy

    respond_to do |format|
      format.html { redirect_to benchmark_types_url }
      format.json { head :no_content }
    end
  end
end

class CpuGridSummariesController < ApplicationController
  # GET /cpu_grid_summaries
  # GET /cpu_grid_summaries.json
  def index
    @cpu_grid_summaries = CpuGridSummary.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @cpu_grid_summaries }
    end
  end

  # GET /cpu_grid_summaries/1
  # GET /cpu_grid_summaries/1.json
  def show
    @cpu_grid_summary = CpuGridSummary.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @cpu_grid_summary }
    end
  end

  # GET /cpu_grid_summaries/new
  # GET /cpu_grid_summaries/new.json
  def new
    @cpu_grid_summary = CpuGridSummary.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @cpu_grid_summary }
    end
  end

  # GET /cpu_grid_summaries/1/edit
  def edit
    @cpu_grid_summary = CpuGridSummary.find(params[:id])
  end

  # POST /cpu_grid_summaries
  # POST /cpu_grid_summaries.json
  def create
    @cpu_grid_summary = CpuGridSummary.new(params[:cpu_grid_summary])

    respond_to do |format|
      if @cpu_grid_summary.save
        format.html { redirect_to @cpu_grid_summary, :notice => 'Cpu grid summary was successfully created.' }
        format.json { render :json => @cpu_grid_summary, :status => :created, :location => @cpu_grid_summary }
      else
        format.html { render :action => "new" }
        format.json { render :json => @cpu_grid_summary.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /cpu_grid_summaries/1
  # PUT /cpu_grid_summaries/1.json
  def update
    @cpu_grid_summary = CpuGridSummary.find(params[:id])

    respond_to do |format|
      if @cpu_grid_summary.update_attributes(params[:cpu_grid_summary])
        format.html { redirect_to @cpu_grid_summary, :notice => 'Cpu grid summary was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @cpu_grid_summary.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /cpu_grid_summaries/1
  # DELETE /cpu_grid_summaries/1.json
  def destroy
    @cpu_grid_summary = CpuGridSummary.find(params[:id])
    @cpu_grid_summary.destroy

    respond_to do |format|
      format.html { redirect_to cpu_grid_summaries_url }
      format.json { head :no_content }
    end
  end
end

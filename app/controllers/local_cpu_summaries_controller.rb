class LocalCpuSummariesController < ApplicationController
  skip_before_filter :userAuthenticate
  # GET /local_cpu_summaries
  # GET /local_cpu_summaries.json
  def index
    @local_cpu_summaries = LocalCpuSummary.paginate :page=>params[:page], :order=>'id desc', :per_page => 20

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @local_cpu_summaries }
    end
  end

  # GET /local_cpu_summaries/1
  # GET /local_cpu_summaries/1.json
  def show
    @local_cpu_summary = LocalCpuSummary.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @local_cpu_summary }
    end
  end

  # GET /local_cpu_summaries/new
  # GET /local_cpu_summaries/new.json
  def new
    @local_cpu_summary = LocalCpuSummary.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @local_cpu_summary }
    end
  end

  # GET /local_cpu_summaries/1/edit
  def edit
    @local_cpu_summary = LocalCpuSummary.find(params[:id])
  end

  # POST /local_cpu_summaries
  # POST /local_cpu_summaries.json
  def create
    @local_cpu_summary = LocalCpuSummary.new(params[:local_cpu_summary])

    respond_to do |format|
      if @local_cpu_summary.save
        format.html { redirect_to @local_cpu_summary, :notice => 'Local cpu summary was successfully created.' }
        format.json { render :json => @local_cpu_summary, :status => :created, :location => @local_cpu_summary }
      else
        format.html { render :action => "new" }
        format.json { render :json => @local_cpu_summary.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /local_cpu_summaries/1
  # PUT /local_cpu_summaries/1.json
  def update
    @local_cpu_summary = LocalCpuSummary.find(params[:id])

    respond_to do |format|
      if @local_cpu_summary.update_attributes(params[:local_cpu_summary])
        format.html { redirect_to @local_cpu_summary, :notice => 'Local cpu summary was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @local_cpu_summary.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /local_cpu_summaries/1
  # DELETE /local_cpu_summaries/1.json
  def destroy
    @local_cpu_summary = LocalCpuSummary.find(params[:id])
    @local_cpu_summary.destroy

    respond_to do |format|
      format.html { redirect_to local_cpu_summaries_url }
      format.json { head :no_content }
    end
  end
end

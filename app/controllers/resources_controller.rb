class ResourcesController < ApplicationController
  skip_before_filter :userAuthenticate
  # GET /resources
  # GET /resources.json
  # GET /resources.xml
  def index
    @resources = Resource.all
    
    respond_to do |format|
      format.html # index.html.erb
      format.json {  
        render :json => @resources.to_json(:include => { :site => {:only => :name}, :resource_type => {:only => :name} }) 
       }
      format.xml {
         render :xml => @resources.to_xml(:include => { :site => {:only => :name}, :resource_type => {:only => :name} })
       }
    end
  end

  # GET /resources/1
  # GET /resources/1.json
  # GET /resources/1.xml
  def show
    @resource = Resource.find(params[:id])
    if @resource.public_methods.member?("cloud_records")
      @cloud_records = @resource.cloud_records.paginate :page=>params[:page], :order=>'id desc', :per_page => 5 
      @stats = {}
      @stats[:records_count]= @resource.cloud_records.count
      @stats[:earliest_record] = @resource.cloud_records.minimum(:endTime)
      @stats[:latest_record] = @resource.cloud_records.maximum(:endTime)
      @stats[:sum_wall] = @resource.cloud_records.sum(:wallDuration)

      data_table = GoogleVisualr::DataTable.new
      # Add Column Headers
      data_table.new_column('date', 'date' )
      data_table.new_column('number', 'started')
      data_table.new_column('number', 'started-ended')
      data_table.new_column('number', 'running')

      # Add Rows and Values

      started = {}
      running = {}
      @resource.cloud_records.find_each(:batch_size => 50) do |r|
        dateStart = DateTime.parse("#{r['startTime']}").to_date
        if started[dateStart]
          started[dateStart] += 1
        else
        started[dateStart] = 1
        end
      end
      actualRunning = 0
      started.sort.each do |date,startedCount|
        partial = startedCount-@resource.cloud_records.where("date(endTime)=\"#{date}\"").count
        actualRunning = running[date] = actualRunning + partial
        data_table.add_row([date,startedCount,partial,actualRunning])
      end

      option = { :width => 800, :height => 400, :title => 'Running VMs' }
      @chart = GoogleVisualr::Interactive::AreaChart.new(data_table, option)
    end
  
    @storage_records = @resource.storage_records.paginate :page=>params[:page], :order=>'id desc', :per_page => 5 if @resource.public_methods.member?("storage_records")
    @grid_cpu_records = @resource.grid_cpu_records.paginate :page=>params[:page], :order=>'id desc', :per_page => 5 if @resource.public_methods.member?("grid_cpu_records") 
    @torque_execute_records = @resource.torque_execute_records.paginate :page=>params[:page], :order=>'id desc', :per_page => 5 if @resource.public_methods.member?("torque_execute_records")

    respond_to do |format|
      format.html # show.html.erb
      format.json {  
        render :json => @resource.to_json(:include => { :site => {:only => :name}, :resource_type => {:only => :name} }) 
       }
       format.xml {
         render :xml => @resource.to_xml(:include => { :site => {:only => :name}, :resource_type => {:only => :name} })
       }
    end
  end

  # GET /resources/new
  # GET /resources/new.json
  def new
    @resource = Resource.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @resource }
    end
  end

  # GET /resources/1/edit
  def edit
    @resource = Resource.find(params[:id])
  end

  # POST /resources
  # POST /resources.json
  def create
    @resource = Resource.new(params[:resource])
    if (params[:site_name]) #HTML form
    @resource.site = Site.find_by_name(params[:site_name])
    end
    if (params[:resource_type_name]) #HTML form
    @resource.resource_type = ResourceType.find_by_name(params[:resource_type_name])
    end
    respond_to do |format|
      if @resource.save
        format.html { redirect_to @resource, :notice => 'Resource was successfully created.' }
        format.json { render :json => @resource, :status => :created, :location => @resource }
      else
        format.html { render :action => "new" }
        format.json { render :json => @resource.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /resources/1
  # PUT /resources/1.json
  def update
    @resource = Resource.find(params[:id])

    respond_to do |format|
      if @resource.update_attributes(params[:resource])
        format.html { redirect_to @resource, :notice => 'Resource was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @resource.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /resources/1
  # DELETE /resources/1.json
  def destroy
    @resource = Resource.find(params[:id])
    @resource.destroy

    respond_to do |format|
      format.html { redirect_to resources_url }
      format.json { head :no_content }
    end
  end
end

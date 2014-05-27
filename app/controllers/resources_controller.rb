class ResourcesController < ApplicationController
  skip_before_filter :userAuthenticate
  # GET /resources
  # GET /resources.json
  # GET /resources.xml
  def index
    @resources = Resource.joins(:site,:resource_type).select("resources.id as resource_id, resources.name as resource_name,sites.name as site_name,resource_types.name as type_name").paginate( :page=>params[:page], :per_page => config.itemsPerPageHTML).orderByParms('resource_name',params)
   
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
    
    if @resource.resource_type.name == "Database"
      @database_schemes = @resource.database_schemes
    end
    
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
      format.xml { render :xml => @resource }
    end
  end

  # GET /resources/1/edit
  def edit
    @resource = Resource.find(params[:id])
  end

  # POST /resources
  # POST /resources.json
  def create
    if params[:resource][:site_name]
      params[:site_name] = params[:resource].delete(:site_name)
    end
    if params[:resource][:resource_type_name]
      params[:resource_type_name] = params[:resource].delete(:resource_type_name)
    end
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
        format.xml { render :xml => @resource, :status => :created, :location => @resource }
      else
        format.html { render :action => "new" }
        format.json { render :json => @resource.errors, :status => :unprocessable_entity }
        format.xml { render :xml => @resource.errors, :status => :unprocessable_entity }
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
        format.xml { head :no_content }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @resource.errors, :status => :unprocessable_entity }
        format.xml { render :xml => @resource.errors, :status => :unprocessable_entity }
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
      format.xml { head :no_content }
    end
  end
end

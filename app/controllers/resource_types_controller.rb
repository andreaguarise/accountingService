class ResourceTypesController < ApplicationController
  skip_before_filter :userAuthenticate
  # GET /resource_types
  # GET /resource_types.json
  def index
    @resource_types = ResourceType.orderByParms('name',params).search(params[:key],params[:search])
    @resourceByType = ResourceType.joins(:resources).group(:resource_type_id).count
    @publisherByType = ResourceType.joins(:publishers).group(:resource_type_id).count  

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @resource_types }
      format.xml { render :xml => @resource_types }
    end
  end

  # GET /resource_types/1
  # GET /resource_types/1.json
  def show
    @resource_type = ResourceType.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @resource_type }
      format.xml { render :xml => @resource_type }
    end
  end

  # GET /resource_types/new
  # GET /resource_types/new.json
  def new
    @resource_type = ResourceType.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @resource_type }
      format.xml { render :xml => @resource_type }
    end
  end

  # GET /resource_types/1/edit
  def edit
    @resource_type = ResourceType.find(params[:id])
  end

  # POST /resource_types
  # POST /resource_types.json
  def create
    @resource_type = ResourceType.new(params[:resource_type])

    respond_to do |format|
      if @resource_type.save
        format.html { redirect_to @resource_type, :notice => 'Resource type was successfully created.' }
        format.json { render :json => @resource_type, :status => :created, :location => @resource_type }
        format.xml { render :xml => @resource_type, :status => :created, :location => @resource_type }
      else
        format.html { render :action => "new" }
        format.json { render :json => @resource_type.errors, :status => :unprocessable_entity }
        format.xml { render :xml => @resource_type.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /resource_types/1
  # PUT /resource_types/1.json
  def update
    @resource_type = ResourceType.find(params[:id])

    respond_to do |format|
      if @resource_type.update_attributes(params[:resource_type])
        format.html { redirect_to @resource_type, :notice => 'Resource type was successfully updated.' }
        format.json { head :no_content }
        format.xml { head :no_content }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @resource_type.errors, :status => :unprocessable_entity }
        format.xml { render :xml => @resource_type.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /resource_types/1
  # DELETE /resource_types/1.json
  def destroy
    @resource_type = ResourceType.find(params[:id])
    @resource_type.destroy

    respond_to do |format|
      format.html { redirect_to resource_types_url }
      format.json { head :no_content }
      format.xml { head :no_content }
    end
  end
end

class PublishersController < ApplicationController
  #skip_before_filter :publisherAuthenticate
  skip_before_filter :userAuthenticate
  # GET /publishers
  # GET /publishers.json
  def index
    @publishers = Publisher.joins(:resource,:resource => :site).select(
      "publishers.id as publisher_id, 
      publishers.hostname as publisher_hostname,
      sites.name as site_name,resources.name as resource_name, 
      publishers.ip as publisher_ip, publishers.token as publisher_token").paginate( :page=>params[:page], :per_page => config.itemsPerPageHTML).orderByParms('publisher_hostname',params).search(params[:key],params[:search])
    respond_to do |format|
      format.html {}
      format.any(:xml,:json) {}
    end
    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @publishers }
      format.xml { render :xml => @publishers }
    end
  end

  # GET /publishers/1
  # GET /publishers/1.json
  def show
    @publisher = Publisher.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @publisher }
    end
  end

  # GET /publishers/new
  # GET /publishers/new.json
  def new
    @publisher = Publisher.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @publisher }
    end
  end

  # GET /publishers/1/edit
  def edit
    @publisher = Publisher.find(params[:id])
  end

  # POST /publishers
  # POST /publishers.json
  def create
    if params[:publisher][:resource_name]
      params[:resource_name] = params[:publisher].delete(:resource_name)
    end
    @publisher = Publisher.new(params[:publisher])
    if (params[:resource_name]) #HTML form
    @publisher.resource = Resource.find_by_name(params[:resource_name])
    end
    
    respond_to do |format|
      if @publisher.save
        format.html { redirect_to @publisher, :notice => 'Publisher was successfully created.' }
        format.json { render :json => @publisher, :status => :created, :location => @publisher }
        format.xml { render :xml => @publisher, :status => :created, :location => @publisher }
      else
        format.html { render :action => "new" }
        format.json { render :json => @publisher.errors, :status => :unprocessable_entity }
        format.xml { render :xml => @publisher.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /publishers/1
  # PUT /publishers/1.json
  def update
    @publisher = Publisher.find(params[:id])

    respond_to do |format|
      if @publisher.update_attributes(params[:publisher])
        format.html { redirect_to @publisher, :notice => 'Publisher was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @publisher.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /publishers/1
  # DELETE /publishers/1.json
  def destroy
    @publisher = Publisher.find(params[:id])
    @publisher.destroy

    respond_to do |format|
      format.html { redirect_to publishers_url }
      format.json { head :no_content }
    end
  end
end

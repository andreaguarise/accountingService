class SitesController < ApplicationController
  skip_before_filter :userAuthenticate
  # GET /sites
  # GET /sites.json
  def index
    @sites = Site.paginate( :page=>params[:page], :per_page => config.itemsPerPageHTML).orderByParms('name',params).search(params[:key],params[:search])
    
    @emiStorageBySite = EmiStorageRecord.group(:site).count #FIXME this should go through joins as for the other record types
    @blahBySite = Site.joins(:blah_records).group(:site_id).count
    @batchBySite = Site.joins(:batch_execute_records).group(:site_id).count
    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @sites }
    end
  end

  # GET /sites/1
  # GET /sites/1.json
  def show
    @stats = []
    @site = Site.find(params[:id])
    if @site.public_methods.member?("cloud_records")
      @stats << ["cloud",@site.cloud_records.count,@site.cloud_records.minimum(:endTime),@site.cloud_records.maximum(:endTime)]
    end
    if @site.public_methods.member?("blah_records")
      @stats << ["grid",@site.blah_records.count,@site.blah_records.minimum(:recordDate),@site.blah_records.maximum(:recordDate)]
    end
    if @site.public_methods.member?("batch_execute_records")
      @stats << ["batch",@site.batch_execute_records.count,@site.batch_execute_records.minimum(:recordDate),@site.batch_execute_records.maximum(:recordDate)]
    end
    if true #FXME should be as for other record types
      @stats << ["storage",EmiStorageRecord.where(:site => @site.name).count,"NA","NA"]
    end

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @site }
    end
  end
  
  # GET /sites/searchid?name=string
  def searchid
    @site = Site.find_by_name(params[:name])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @site.id }
    end
  end

  # GET /sites/new
  # GET /sites/new.json
  def new
    @site = Site.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @site }
    end
  end

  # GET /sites/1/edit
  def edit
    @site = Site.find(params[:id])
  end

  # POST /sites
  # POST /sites.json
  def create
    @site = Site.new(params[:site])

    respond_to do |format|
      if @site.save
        format.html { redirect_to @site, :notice => 'Site was successfully created.' }
        format.json { render :json => @site, :status => :created, :location => @site }
      else
        format.html { render :action => "new" }
        format.json { render :json => @site.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /sites/1
  # PUT /sites/1.json
  def update
    @site = Site.find(params[:id])
    skipMassAssign :site

    respond_to do |format|
      if @site.update_attributes(params[:site])
        format.html { redirect_to @site, :notice => 'Site was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @site.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /sites/1
  # DELETE /sites/1.json
  def destroy
    @site = Site.find(params[:id])
    @site.destroy

    respond_to do |format|
      format.html { redirect_to sites_url }
      format.json { head :no_content }
    end
  end
end

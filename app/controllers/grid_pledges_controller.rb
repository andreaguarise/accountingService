class GridPledgesController < ApplicationController
  # GET /grid_pledges
  # GET /grid_pledges.json
  def index
    @grid_pledges = GridPledge.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @grid_pledges }
    end
  end

  # GET /grid_pledges/1
  # GET /grid_pledges/1.json
  def show
    @grid_pledge = GridPledge.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @grid_pledge }
    end
  end

  # GET /grid_pledges/new
  # GET /grid_pledges/new.json
  def new
    @grid_pledge = GridPledge.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @grid_pledge }
    end
  end

  # GET /grid_pledges/1/edit
  def edit
    @grid_pledge = GridPledge.find(params[:id])
  end

  # POST /grid_pledges
  # POST /grid_pledges.json
  def create
    @grid_pledge = GridPledge.new(params[:grid_pledge])

    respond_to do |format|
      if @grid_pledge.save
        format.html { redirect_to @grid_pledge, :notice => 'Grid pledge was successfully created.' }
        format.json { render :json => @grid_pledge, :status => :created, :location => @grid_pledge }
      else
        format.html { render :action => "new" }
        format.json { render :json => @grid_pledge.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /grid_pledges/1
  # PUT /grid_pledges/1.json
  def update
    @grid_pledge = GridPledge.find(params[:id])

    respond_to do |format|
      if @grid_pledge.update_attributes(params[:grid_pledge])
        format.html { redirect_to @grid_pledge, :notice => 'Grid pledge was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @grid_pledge.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /grid_pledges/1
  # DELETE /grid_pledges/1.json
  def destroy
    @grid_pledge = GridPledge.find(params[:id])
    @grid_pledge.destroy

    respond_to do |format|
      format.html { redirect_to grid_pledges_url }
      format.json { head :no_content }
    end
  end
end

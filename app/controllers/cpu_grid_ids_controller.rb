class CpuGridIdsController < ApplicationController
  # GET /cpu_grid_ids
  # GET /cpu_grid_ids.json
  def index
    @cpu_grid_ids = CpuGridId.paginate(:page=>params[:page], :per_page => config.itemsPerPageHTML).all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @cpu_grid_ids }
      format.xml { render :xml => @cpu_grid_ids }
    end
  end

  # GET /cpu_grid_ids/1
  # GET /cpu_grid_ids/1.json
  def show
    @cpu_grid_id = CpuGridId.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @cpu_grid_id }
      format.json { render :xml => @cpu_grid_id }
    end
  end
end

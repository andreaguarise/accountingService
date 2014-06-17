class CpuGridIdsController < ApplicationController
  # GET /cpu_grid_ids
  # GET /cpu_grid_ids.json
  def index
    @cpu_grid_ids = CpuGridId.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @cpu_grid_ids }
    end
  end

  # GET /cpu_grid_ids/1
  # GET /cpu_grid_ids/1.json
  def show
    @cpu_grid_id = CpuGridId.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @cpu_grid_id }
    end
  end
end

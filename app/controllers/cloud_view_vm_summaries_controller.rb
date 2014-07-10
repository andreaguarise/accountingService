class CloudViewVmSummariesController < ApplicationController
  # GET /cloud_view_vm_summaries
  # GET /cloud_view_vm_summaries.json
  def index
    @cloud_view_vm_summaries = CloudViewVmSummary.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @cloud_view_vm_summaries }
      format.xml { render :xml => @cloud_view_vm_summaries }
    end
  end

  # GET /cloud_view_vm_summaries/1
  # GET /cloud_view_vm_summaries/1.json
  def show
    @cloud_view_vm_summary = CloudViewVmSummary.find_by_id(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @cloud_view_vm_summary }
      format.xml { render :xml => @cloud_view_vm_summary }
    end
  end
end

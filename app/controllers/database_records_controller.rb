class DatabaseRecordsController < ApplicationController
  # GET /database_records
  # GET /database_records.json
  def index
    @database_records = DatabaseRecord.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @database_records }
    end
  end

  # GET /database_records/1
  # GET /database_records/1.json
  def show
    @database_record = DatabaseRecord.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @database_record }
    end
  end

  # GET /database_records/new
  # GET /database_records/new.json
  def new
    @database_record = DatabaseRecord.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @database_record }
    end
  end

  # GET /database_records/1/edit
  def edit
    @database_record = DatabaseRecord.find(params[:id])
  end

  # POST /database_records
  # POST /database_records.json
  def create
    @database_record = DatabaseRecord.new(params[:database_record])

    respond_to do |format|
      if @database_record.save
        format.html { redirect_to @database_record, :notice => 'Database record was successfully created.' }
        format.json { render :json => @database_record, :status => :created, :location => @database_record }
      else
        format.html { render :action => "new" }
        format.json { render :json => @database_record.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /database_records/1
  # PUT /database_records/1.json
  def update
    @database_record = DatabaseRecord.find(params[:id])

    respond_to do |format|
      if @database_record.update_attributes(params[:database_record])
        format.html { redirect_to @database_record, :notice => 'Database record was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @database_record.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /database_records/1
  # DELETE /database_records/1.json
  def destroy
    @database_record = DatabaseRecord.find(params[:id])
    @database_record.destroy

    respond_to do |format|
      format.html { redirect_to database_records_url }
      format.json { head :no_content }
    end
  end
end

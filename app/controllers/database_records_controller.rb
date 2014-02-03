class DatabaseRecordsController < ApplicationController
  skip_before_filter :userAuthenticate
  # GET /database_records
  # GET /database_records.json
  def index
    @database_records = DatabaseRecord.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @database_records }
      format.xml { render :xml => @database_records }
    end
  end

  # GET /database_records/1
  # GET /database_records/1.json
  def show
    @database_record = DatabaseRecord.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @database_record }
      format.xml { render :xml => @database_record }
    end
  end

  # GET /database_records/new
  # GET /database_records/new.json
  def new
    @database_record = DatabaseRecord.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @database_record }
      format.xml { render :xml => @database_record }
    end
  end

  # GET /database_records/1/edit
  def edit
    @database_record = DatabaseRecord.find(params[:id])
  end

  # POST /database_records
  # POST /database_records.json
  def create
    if params[:database_record][:schema]
      params[:schema] = params[:database_record].delete(:schema)
    end
    if params[:database_record][:table]
      params[:table] = params[:database_record].delete(:table)
    end
    if params[:database_record][:time]
      params[:database_record][:time] = Time.at(params[:database_record][:time]).to_datetime
    end
    @database_record = DatabaseRecord.new(params[:database_record])
    publisher = Publisher.find_by_token(session[:token])
    schema = DatabaseScheme.find_by_name(params[:schema])
    logger.info "Received API-KEY:#{session[:token]}, which maps to :#{publisher.hostname}"
    logger.info "Received schema:#{params[:schema]}, which maps to dbid:#{schema.id}"
    if ( schema.publisher_id != publisher.id )
      logger.info "Forbidden"
      respond_to do |format|
        format.json { render :json => @database_record.errors, :status => :unprocessable_entity }
      end
    end
    t = schema.database_table.find_by_name(params[:table])
    if ( t )
      #table exists in authorized schema. Using it
      @database_record.database_table_id=t.id
    else
      #table does not exists in authorized schema create and use it
      t = DatabaseTable.new
      t.name = params[:table]
      t.database_scheme_id = schema.id
      t.save
      @database_record.database_table_id=t.id     
    end
    respond_to do |format|
      if @database_record.save
        format.html { redirect_to @database_record, :notice => 'Database record was successfully created.' }
        format.json { render :json => @database_record, :status => :created, :location => @database_record }
        format.xml { render :xml => @database_record, :status => :created, :location => @database_record }
      else
        format.html { render :action => "new" }
        format.json { render :json => @database_record.errors, :status => :unprocessable_entity }
        format.xml { render :xml => @database_record.errors, :status => :unprocessable_entity }
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
        format.xml { head :no_content }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @database_record.errors, :status => :unprocessable_entity }
        format.xml { render :xml => @database_record.errors, :status => :unprocessable_entity }
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
      format.xml { head :no_content }
    end
  end
end

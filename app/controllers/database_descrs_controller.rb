class DatabaseDescrsController < ApplicationController
  skip_before_filter :userAuthenticate
  # GET /database_descrs
  # GET /database_descrs.json
  def index
    @database_descrs = DatabaseDescr.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @database_descrs }
    end
  end

  # GET /database_descrs/1
  # GET /database_descrs/1.json
  def show
    @database_descr = DatabaseDescr.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @database_descr }
    end
  end

  # GET /database_descrs/new
  # GET /database_descrs/new.json
  def new
    @database_descr = DatabaseDescr.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @database_descr }
    end
  end

  # GET /database_descrs/1/edit
  def edit
    @database_descr = DatabaseDescr.find(params[:id])
  end

  # POST /database_descrs
  # POST /database_descrs.json
  def create
    @database_descr = DatabaseDescr.new(params[:database_descr])

    respond_to do |format|
      if @database_descr.save
        format.html { redirect_to @database_descr, :notice => 'Database descr was successfully created.' }
        format.json { render :json => @database_descr, :status => :created, :location => @database_descr }
      else
        format.html { render :action => "new" }
        format.json { render :json => @database_descr.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /database_descrs/1
  # PUT /database_descrs/1.json
  def update
    @database_descr = DatabaseDescr.find(params[:id])

    respond_to do |format|
      if @database_descr.update_attributes(params[:database_descr])
        format.html { redirect_to @database_descr, :notice => 'Database descr was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @database_descr.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /database_descrs/1
  # DELETE /database_descrs/1.json
  def destroy
    @database_descr = DatabaseDescr.find(params[:id])
    @database_descr.destroy

    respond_to do |format|
      format.html { redirect_to database_descrs_url }
      format.json { head :no_content }
    end
  end
end

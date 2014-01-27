class DatabaseSchemesController < ApplicationController
  # GET /database_schemes
  # GET /database_schemes.json
  def index
    @database_schemes = DatabaseScheme.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @database_schemes }
    end
  end

  # GET /database_schemes/1
  # GET /database_schemes/1.json
  def show
    @database_scheme = DatabaseScheme.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @database_scheme }
    end
  end

  # GET /database_schemes/new
  # GET /database_schemes/new.json
  def new
    @database_scheme = DatabaseScheme.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @database_scheme }
    end
  end

  # GET /database_schemes/1/edit
  def edit
    @database_scheme = DatabaseScheme.find(params[:id])
  end

  # POST /database_schemes
  # POST /database_schemes.json
  def create
    @database_scheme = DatabaseScheme.new(params[:database_scheme])

    respond_to do |format|
      if @database_scheme.save
        format.html { redirect_to @database_scheme, :notice => 'Database scheme was successfully created.' }
        format.json { render :json => @database_scheme, :status => :created, :location => @database_scheme }
      else
        format.html { render :action => "new" }
        format.json { render :json => @database_scheme.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /database_schemes/1
  # PUT /database_schemes/1.json
  def update
    @database_scheme = DatabaseScheme.find(params[:id])

    respond_to do |format|
      if @database_scheme.update_attributes(params[:database_scheme])
        format.html { redirect_to @database_scheme, :notice => 'Database scheme was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @database_scheme.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /database_schemes/1
  # DELETE /database_schemes/1.json
  def destroy
    @database_scheme = DatabaseScheme.find(params[:id])
    @database_scheme.destroy

    respond_to do |format|
      format.html { redirect_to database_schemes_url }
      format.json { head :no_content }
    end
  end
end

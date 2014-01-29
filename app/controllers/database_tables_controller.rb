class DatabaseTablesController < ApplicationController
  # GET /database_tables
  # GET /database_tables.json
  def index
    @database_tables = DatabaseTable.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @database_tables }
    end
  end

  # GET /database_tables/1
  # GET /database_tables/1.json
  def show
    @database_table = DatabaseTable.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @database_table }
    end
  end

  # GET /database_tables/new
  # GET /database_tables/new.json
  def new
    @database_table = DatabaseTable.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @database_table }
    end
  end

  # GET /database_tables/1/edit
  def edit
    @database_table = DatabaseTable.find(params[:id])
  end

  # POST /database_tables
  # POST /database_tables.json
  def create
    @database_table = DatabaseTable.new(params[:database_table])

    respond_to do |format|
      if @database_table.save
        format.html { redirect_to @database_table, :notice => 'Database table was successfully created.' }
        format.json { render :json => @database_table, :status => :created, :location => @database_table }
      else
        format.html { render :action => "new" }
        format.json { render :json => @database_table.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /database_tables/1
  # PUT /database_tables/1.json
  def update
    @database_table = DatabaseTable.find(params[:id])

    respond_to do |format|
      if @database_table.update_attributes(params[:database_table])
        format.html { redirect_to @database_table, :notice => 'Database table was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @database_table.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /database_tables/1
  # DELETE /database_tables/1.json
  def destroy
    @database_table = DatabaseTable.find(params[:id])
    @database_table.destroy

    respond_to do |format|
      format.html { redirect_to database_tables_url }
      format.json { head :no_content }
    end
  end
end

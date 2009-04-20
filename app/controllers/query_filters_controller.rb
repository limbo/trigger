class QueryFiltersController < ApplicationController
  before_filter :get_account
  
  # GET /filters
  # GET /filters.xml
  def index
    @filters = @account.filters

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @filters }
    end
  end

  # GET /filters/1
  # GET /filters/1.xml
  def show
    @query_filter = @account.filters.find(params[:id])
    
    @updates = Update.find_with_ferret(@query_filter.query, {:sort => Ferret::Search::SortField.new(:message_id, :type => :integer, :reverse => true)})
    @query_filter_name = @query_filter.filter_name
    @members = @updates.group_by(&:sender).keys
    
    # if (@account.last_query_filter_id != @query_filter.id)
    #   @account.last_query_filter_id = params[:id]
    #   @account.save
    # end
    
    respond_to do |format|
      format.html {render :layout => false} # show.html.erb
      format.xml  { render :xml => @query_filter }
    end
  end

  # GET /filters/new
  # GET /filters/new.xml
  def new
    @query_filter = QueryFilter.new
    @query_filter.owner = @account 
    
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @query_filter }
    end
  end

  # GET /filters/1/edit
  def edit
    @query_filter = QueryFilter.find(params[:id])
  end

  # POST /filters
  # POST /filters.xml
  def create
    @query_filter = QueryFilter.new(params[:query_filter])
    @query_filter.owner = @account
    
    respond_to do |format|
      if @query_filter.save
        flash[:notice] = 'Filter was successfully created.'
        format.html { redirect_to(account_path(@account)) }
        format.xml  { render :xml => @query_filter, :status => :created, :location => [@account, @query_filter] }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @query_filter.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /filters/1
  # PUT /filters/1.xml
  def update
    @query_filter = QueryFilter.find(params[:id])

    respond_to do |format|
      if @query_filter.update_attributes(params[:query_filter])
        flash[:notice] = 'Filter was successfully updated.'
        format.html { redirect_to(@account) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @query_filter.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /filters/1
  # DELETE /filters/1.xml
  def destroy
    @query_filter = @account.filters.find(params[:id])
    @query_filter.destroy
    flash[:notice] = 'Filter was successfully deleted.'
    
    respond_to do |format|
      format.html { redirect_to(@account) }
      format.xml  { head :ok }
    end
  end
end

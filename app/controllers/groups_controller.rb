class GroupsController < ApplicationController
  before_filter :get_account
  
  # GET /groups
  # GET /groups.xml
  def index
    @groups = @account.groups

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @groups }
    end
  end

  # GET /groups/1
  # GET /groups/1.xml
  def show
    if params[:id].to_i != 0
      @group = @account.groups.find(params[:id])
      @updates = Update.find_all_by_sender_id(@group.members.collect {|m| m.id}, :limit => 20, :order => 'message_id DESC', :include => :sender)
      @group_name = @group.group_name
      @members = @group.members
    else
      @group_name = 'default'
      @members = @account.friends
      @updates = Update.find(:all, :order => 'message_id DESC', :limit => 20, :include => :sender)
    end
    
    if (@account.last_group_id != params[:id].to_i)
      @account.last_group_id = params[:id]
      @account.save
    end
    
    respond_to do |format|
      format.html {render :layout => false} # show.html.erb
      format.xml  { render :xml => @group }
    end
  end

  # GET /groups/new
  # GET /groups/new.xml
  def new
    @group = Group.new
    @group.owner = @account 
    
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @group }
    end
  end

  # GET /groups/1/edit
  def edit
    @page_count = (@account.friends.size / 100.0).ceil
    @page = params[:page].nil? ? 1 : params[:page].to_i
    @friends = @account.friends
    
    @group = Group.find(params[:id])
  end

  def add
    @group = @account.groups.find(params[:id])
    
    #add user to group
    @membership = params[:members]
    for member in @group.members do
      if @membership.include?(member.login)
        @membership.delete(member.login)
      else
        @group.members.delete(member)
      end
    end

    for new_member in @membership do
      @user = @account.friends.find_by_login(new_member) rescue nil
      @group.members << @user if @user
    end
    @group.save

    render :xml => @group.members
  end
  
  def remove
    @group = @account.groups.find(params[:id])
    @user = Account.find_by_login(params[:user]) rescue nil
    
    @friends = fetch_friends(@account)
    
    #add user to group
    @group.members.delete(@user)
    @group.save
    
    redirect_to edit_account_group_path(@account, @group, {:page => params[:page]})
  end
  
  # POST /groups
  # POST /groups.xml
  def create
    @group = Group.new(params[:group])
    @group.owner = @account
    
    respond_to do |format|
      if @group.save
        flash[:notice] = 'Group was successfully created.'
        format.html { redirect_to(edit_account_group_path(@account, @group)) }
        format.xml  { render :xml => @group, :status => :created, :location => [@account, @group] }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @group.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /groups/1
  # PUT /groups/1.xml
  def update
    @group = Group.find(params[:id])

    respond_to do |format|
      if @group.update_attributes(params[:group])
        flash[:notice] = 'Group was successfully updated.'
        format.html { redirect_to(@account) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @group.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /groups/1
  # DELETE /groups/1.xml
  def destroy
    @group = Group.find(params[:id])
    @group.destroy

    respond_to do |format|
      format.html { redirect_to(groups_url) }
      format.xml  { head :ok }
    end
  end
end

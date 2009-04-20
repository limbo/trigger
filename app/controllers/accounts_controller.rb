class AccountsController < ApplicationController
  before_filter :login_required
  
  # Used throughout the controller.
  def self.consumer
    # The readkey and readsecret below are the values you get during registration
    OAuth::Consumer.new("2GtW6yZnutgBagf6kf6sw",
      "VUC12ywJelM5B3hm1YvaiFzDefvXCAPyf1tTAlJkQ",
      { :site=>"http://twitter.com" })
  end
  
  def authenticate
    @request_token = AccountsController.consumer.get_request_token
    session[:request_token] = @request_token.token
    session[:request_token_secret] = @request_token.secret
    # Send to twitter.com to authorize
    redirect_to @request_token.authorize_url
    return
  end
  
  def manage
    @accounts = current_user.accounts
  end

  def index
    redirect_to :action => 'show'
  end
  
  def show
    if params[:id]
      @account = current_user.accounts.find(params[:id])
    else
      @account = current_user.last_account
    end
    
    if @account.nil?
      redirect_to :action => 'manage' and return
    end
    
    @filters = @account.filters
    if current_user.last_account != @account
      current_user.last_account = @account
      current_user.save
    end
    
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @account }
    end
  end

  def info
    @account = current_user.accounts.find(params[:id])
    @me = fetch_info(@account)
  end
  
  def new
    @account = Account.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @account }
    end
  end

  def create
    @account = Account.new(params[:account])
    @account.owner = current_user
    
    # inital message + friend fetch for account
    # also tests authentication
    validated = validate_twitter_account(@account)
    if validated
      @account.sync
      
      respond_to do |format|
        if @account.save
          # set default account on owner if none set yet.
          if @account.owner.last_account.nil?
            @account.owner.last_account = @account
            @account.owner.save
          end
          
          # create default group
          default_group = @account.create_default_group
          @account.last_group = default_group
          @account.save
          
#          msgs = fetch_messages @account
# TODO: add asynchronous message import at this point.
          flash[:notice] = "Account was successfully registered."
          format.html { redirect_to(@account) }
          format.xml  { render :xml => @account, :status => :created, :location => @account }
        else
          format.html { render :action => "new" }
          format.xml  { render :xml => @account.errors, :status => :unprocessable_entity }
        end
      end
    else
      @account.errors.add_to_base "Could not validate account."
      render :action => 'new'
    end
    
  end

  def edit
  end

  def update
  end

  def destroy
    @account = current_user.accounts.find(params[:id])
    @account.destroy

    respond_to do |format|
      format.html { redirect_to(manage_accounts_url) }
      format.xml  { head :ok }
    end
  end
end

class MessagesController < ApplicationController
  before_filter :login_required
  before_filter :get_account
  
  def index
    @account = current_user.accounts.find_by_id(params[:account_id])
    
    @db_msgs = Update.find(:all, :order => 'message_id DESC', :limit => 20, :include => :sender)
    puts "fetching friends..."
    @members = fetch_friends(@account)
    
    puts "done."
  end

  def search
    @updates = Update.find_with_ferret(params[:q])
    @members = @account.friends
    @updates.delete_if {|msg| !@members.include?(msg.sender)}
  end

  def new
  end

  def create
    @update = @account.post(params[:message])
  end

  def reply
  end

  def delete
  end

end

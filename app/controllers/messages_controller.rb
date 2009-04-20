class MessagesController < ApplicationController
  def index
    @account = current_user.accounts.find_by_id(params[:account_id])
    
    @db_msgs = Update.find(:all, :order => 'message_id DESC', :limit => 20, :include => :sender)
    puts "fetching friends..."
    @members = fetch_friends(@account)
    
    puts "done."
  end

  def search
    @messages = Update.find_with_ferret(params[:q])
    @members = []
  end
  
  def new
  end

  def create
  end

  def reply
  end

  def delete
  end

end

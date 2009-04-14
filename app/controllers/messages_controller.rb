class MessagesController < ApplicationController
  def clear
    User.delete_all
    @user = User.find_by_login('limbotest')
    if @user.nil?
      config_file = File.join(File.dirname(__FILE__), '..', '..', 'config', 'twitter.yml')
      twitter = Twitter::Client.from_config(config_file, env = 'development')
      me = twitter.my(:info)
      @user = User.create(:login => 'limbotest', :password => 'cetek', :user_id => me.id)
    end
    @user.last_msg_id = nil
    @user.save
    session[:current_user] = @user
    Update.delete_all
    Group.delete_all
    redirect_to :action => :index
  end
  
  def index
    @account = current_user.accounts.find_by_id(params[:account_id])
    
    @db_msgs = Update.find(:all, :order => 'message_id DESC', :limit => 20, :include => :sender)
    puts "fetching friends..."
    @members = fetch_friends(@account)
    
    puts "done."
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

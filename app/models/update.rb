class Update < ActiveRecord::Base
  acts_as_ferret :fields => {:message_id => {:store => :no},
                             :sender_id => {:store => :no},
                             :sender_name => {:store => :yes}, 
                             :in_reply_to_account_id => {:store => :no},
                             :in_reply_to_update_id => {:store => :no},
                             :message => {:store => :yes},
                             :created_at => {:store => :no}
                             }
  belongs_to :sender, :foreign_key => 'sender_id', :class_name => 'Account'
  belongs_to :in_reply_to_account, :foreign_key => 'in_reply_to_account_id', :class_name => 'Account'
  
  def is_mention_of?(account)
    puts self.message
    puts "/\@#{account.login}/"
    puts self.message.match("@#{account.login}").inspect
    !!self.message.match("@#{account.login}([^a-zA-Z0-9_]|$)")
  end
  
  def sender_name
    sender.login
  end
  
  def self.store_twit(status)
    msg = Update.create(:message_id => status.id, :message => status.text, :created_at => status.created_at)
    msg.in_reply_to_account = status.in_reply_to_user_id.nil? ? nil : Account.find_or_create(status.in_reply_to_user_id) 
    msg.in_reply_to_update_id = status.in_reply_to_status_id
    # msg.is_mention = (account.eql? msg.in_reply_to_account)
    
    sender = Account.find_by_remote_id(status.user.id)
    if (sender.nil?)
      puts status.inspect
      sender = Account.create(:login => status.user.screen_name, 
          :profile_image_url => status.user.profile_image_url, 
          :remote_id => status.user.id)
      sender.save
    end
    msg.sender = sender
    msg.save ? msg : nil
  end
  
end

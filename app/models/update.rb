class Update < ActiveRecord::Base
  acts_as_ferret :fields => {:message_id => {:store => :no},
                             :sender_id => {:store => :no},
                             :sender_name => {:store => :yes}, 
                             :message => {:store => :yes},
                             :created_at => {:store => :no}
                             }
  belongs_to :sender, :foreign_key => 'sender_id', :class_name => 'Account'
  
  def sender_name
    sender.login
  end
end

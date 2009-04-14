class Update < ActiveRecord::Base
  belongs_to :sender, :foreign_key => 'sender_id', :class_name => 'Account'
end

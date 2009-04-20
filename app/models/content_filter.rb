class ContentFilter < ActiveRecord::Base
  belongs_to :owner, :class_name => 'Account', :foreign_key => 'owner_id'
end

class Group < ActiveRecord::Base
  belongs_to :owner, :class_name => 'Account', :foreign_key => 'owner_id'
  has_and_belongs_to_many :members, :class_name => 'Account', :join_table => 'accounts_groups', :uniq => true
  
  def contains_by_name(name)
    for member in members do
      return true if member.login == name
    end
    return false
  end
end

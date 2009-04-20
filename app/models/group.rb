class Group < ContentFilter
  has_and_belongs_to_many :members, :class_name => 'Account', :join_table => 'accounts_groups', :uniq => true
  
  def contains_by_name(name)
    for member in members do
      return true if member.login == name
    end
    return false
  end
  
  def default_group?
    return is_default == 1
  end
end

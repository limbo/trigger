
class Account < ActiveRecord::Base
  include TwitterClient
  
  has_many :filters, :class_name => 'ContentFilter', :foreign_key => 'owner_id'
  belongs_to :owner, :class_name => 'User', :foreign_key => 'owner_id'
  has_and_belongs_to_many :friends, :class_name => 'Account', :join_table => 'follows', :foreign_key => 'follower_id', :association_foreign_key => 'followed_id', :uniq => true
  belongs_to :last_group, :class_name => 'Group', :foreign_key => 'last_group_id'
  
  def create_default_group
    group = Group.create(:filter_name => 'Default Group', :is_default => true)
    self.filters << group
    group.members << self.friends
    if group.save
      return group
    else
      return nil
    end
  end
  
  def default_group
    for group in self.groups
      return group if group.is_default
    end
    
    nil
  end
  
  def is_following_by_name?(name)
    return !self.friends.find_by_login(name).nil?
  end
  
  def is_following_by_id?(id)
    return !self.friends.find_by_remote_id(id).nil?
  end

  def add_friend(user)
    account = Account.find_by_remote_id(user.id) rescue nil
    puts "#{user.screen_name} - #{account.nil? ? 'not found' : 'found'}"
    if account.nil?
      #create user if we dont have it cached yet
      puts "Creating account for #{user.screen_name}"
      account = Account.create(:login => user.screen_name, :remote_id => user.id, :profile_image_url => user.profile_image_url)
      account.save
    end
    
    self.friends << account
  end
  
  def sync
    friends = fetch_friends(self, p = 0)
    while !friends.empty? do
      for friend in friends do 
        if !self.is_following_by_id?(friend.id)
          self.add_friend(friend)
        end
      end
      friends = fetch_friends(self, p = p+1)
    end
  end
end


class Account < ActiveRecord::Base
  include TwitterClient
  
  has_many :groups, :class_name => 'Group', :foreign_key => 'owner_id'
  belongs_to :owner, :class_name => 'User', :foreign_key => 'owner_id'
  has_and_belongs_to_many :friends, :class_name => 'Account', :join_table => 'follows', :foreign_key => 'follower_id', :association_foreign_key => 'followed_id', :uniq => true

  def is_following?(name)
    return !self.friends.find_by_login(name).nil?
  end
  
  def add_friend(user)
    account = Account.find_by_login(user.login) rescue nil
    
    if @user.nil?
      #create user if we dont have it cached yet
      account = Account.create(:login => user.screen_name, :remote_id => user.id, :profile_image_url => user.profile_image_url)
      account.save
    end
    
    self.friends << account
  end
  
  def sync
    friends = fetch_friends(self, p = 0)
    while !friends.empty? do
      for friend in friends do 
        if !self.is_following?(friend.screen_name)
          self.add_friend(friend)
        end
      end
      friends = fetch_friends(self, p = p+1)
    end
  end
end

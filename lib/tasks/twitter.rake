require 'twitter_client'

namespace :twitter do  
  include TwitterClient

  desc "Fetch twitter messages for all accounts"
  task :fetch_all_messages => [:environment] do
    @users = User.find(:all)
    for user in @users do
      for account in user.accounts do
        fetch_messages(account)
      end
    end
  end
end
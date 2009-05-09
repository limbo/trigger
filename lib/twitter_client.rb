require 'rubygems'
gem('mbbx6spp-twitter4r')
require 'twitter'
require 'twitter/console'
require 'time'

module TwitterClient
  protected 
    def client(account = self)
      Twitter::Client.new(:login => account.login, :password => account.password)
    end
    
    def validate_twitter_account(account)
      puts "Validating account with #{account.login}:#{account.password}"
      client = Twitter::Client.new
      return client.authenticate?(account.login, account.password)
    end

    def fetch_info(account)
      client = Twitter::Client.new(:login => account.login, :password => account.password)
      return Twitter::User.find(account.login, client)
    end

    def update_friends(account)
      friends = fetch_friends(account, p = 0)
      while !friends.empty? do
        for friend in friends do 
          if !account.is_following_by_id?(friend.id)
            account.add_friend(friend)
          end
        end
        friends = fetch_friends(account, p = p+1)
      end
      account.save
    end
    
    def fetch_friends(account, page = 1)
      puts "Fetching friends for #{account.login} page: #{page}"
      begin
        twitter = Twitter::Client.new :login => account.login, :password => account.password
        return twitter.my(:friends, :page => page)
      rescue => e
        logger.error e
        return []
      end
    end 

    def fetch_friend(account, friend)
      begin
        twitter = Twitter::Client.new :login => account.login, :password => account.password
        return twitter.user(friend)
      rescue => e
        logger.error e
        return nil
      end
    end

    def fetch_account_by_id(id)
      twitter = Twitter::Client.new
      return twitter.user(friend)
    end
    
    def fetch_messages(account)
      begin
  #        config_file = File.join(File.dirname(__FILE__), '..', '..', 'config', 'twitter.yml')
        twitter = Twitter::Client.new(:login => account.login, :password => account.password)

        options = {:count => 200}
        if account.last_msg_id
          options[:since_id] = account.last_msg_id
        end
        puts "fetch timeline for user with options: #{options.inspect}"
        @msgs = twitter.timeline_for(:friends, options) do |status|
          next if Update.find_by_message_id(status.id)

          # save message in db
          msg = Update.create(:message_id => status.id, :message => status.text, :created_at => status.created_at)
          msg.in_reply_to_account = status.in_reply_to_user_id.nil? ? nil : Account.find_or_create(status.in_reply_to_user_id) 
          msg.in_reply_to_update_id = status.in_reply_to_status_id
          msg.is_mention = (account.eql? msg.in_reply_to_account)
          
          sender = Account.find_by_remote_id(status.user.id)
          if (sender.nil?)
            puts status.inspect
            sender = Account.create(:login => status.user.screen_name, 
                :profile_image_url => status.user.profile_image_url, 
                :remote_id => status.user.id)
            sender.save
          end
          msg.sender = sender
          msg.save
          # update user's last seen message
          account.last_msg_id = status.id if (account.last_msg_id.nil? || status.id > account.last_msg_id)
        end
        account.save
        puts "done."
      rescue => e
        puts e
      end
      @msgs.count rescue 0
    end
end

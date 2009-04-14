require 'rubygems'
gem('mbbx6spp-twitter4r')
require 'twitter'
require 'twitter/console'
require 'time'

module TwitterClient
  protected 
  
    def validate_twitter_account(account)
      puts "Validating account with #{account.login}:#{account.password}"
      client = Twitter::Client.new
      return client.authenticate?(account.login, account.password)
    end

    def fetch_info(account)
      client = Twitter::Client.new(:login => account.login, :password => account.password)
      return Twitter::User.find(account.login, client)
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
          # save message in db
          msg = Update.create(:message_id => status.id, :message => status.text, :created_at => status.created_at)
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
        logger.error e
      end
      @msgs.count rescue 0
    end
end

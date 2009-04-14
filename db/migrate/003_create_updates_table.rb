class CreateUpdatesTable < ActiveRecord::Migration
  
  # #<Twitter::Status:0x504c54 
  # @client=#<Twitter::Client:0x55a4c4 @login="limbotest", @password="cetek05">, 
  # @created_at=Wed Mar 04 12:31:59 -0800 2009, 
  # @text="time is up, I was at the versace mansion", 
  # @id=1280208362, 
  # @user=#<Twitter::User:0x504984 @screen_name="THE_REAL_SHAQ", @location="PHOENIX/EVERYWERE", @description="VERY QUOTATIOUS, I PERFORM RANDOM ACTS OF SHAQNESS", @protected=false, @profile_image_url="http://s3.amazonaws.com/twitter_production/profile_images/75257283/Shaq_avatar_normal.jpg", @id=17461978, @url=nil, @name="THE_REAL_SHAQ">>
  
  def self.up
    create_table :updates, :force => true do |t|
      t.column 'message_id', :integer
      t.column 'sender_id', :integer
      t.column 'message', :string
      t.timestamps
    end
  end

  def self.down
    drop_table :updates
  end
end

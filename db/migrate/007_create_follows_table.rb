class CreateFollowsTable < ActiveRecord::Migration
  def self.up
    create_table :follows, :force => true, :id => false, :primary_key => [:follower_id, :followed_id] do |t|
      t.column 'follower_id', :integer, :null => false
      t.column 'followed_id', :integer, :null => false
      t.timestamps
    end
  end

  def self.down
    drop_table :follows
  end
end

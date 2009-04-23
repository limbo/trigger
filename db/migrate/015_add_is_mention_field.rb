class AddIsMentionField < ActiveRecord::Migration
  def self.up
    add_column :updates, :in_reply_to_account_id, :int, :default => nil
    add_column :updates, :in_reply_to_update_id, :int, :default => nil
  end

  def self.down
    remove_column :updates, :in_reply_to_account
    remove_column :updates, :in_reply_to_update
  end
end

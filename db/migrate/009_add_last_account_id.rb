class AddLastAccountId < ActiveRecord::Migration
  def self.up
    add_column :users, :last_account_id, :integer, :default => nil
  end

  def self.down
    drop_column :users, :last_account_id
  end
end

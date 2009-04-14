class AddLastGroupId < ActiveRecord::Migration
  def self.up
    add_column :accounts, :last_group_id, :integer, :default => 0
  end

  def self.down
    drop_column :accounts, :last_group_id
  end
end

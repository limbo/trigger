class AddIsDefaultField < ActiveRecord::Migration
  def self.up
    add_column :groups, :is_default, :tinyint, :default => 0
  end

  def self.down
    drop_column :groups, :is_default
  end
end

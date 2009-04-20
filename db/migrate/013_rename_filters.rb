class RenameFilters < ActiveRecord::Migration
  def self.up
    rename_table :filters, :query_filters
  end

  def self.down
    rename_table :query_filters, :filters
  end
end

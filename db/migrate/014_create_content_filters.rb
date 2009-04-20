class CreateContentFilters < ActiveRecord::Migration
  def self.up
    create_table :content_filters do |t|
      t.string   "type"
      t.string   "filter_name"
      t.integer  "owner_id"
      t.string   "query"
      t.column   :is_default, :tinyint, :default => 0
      t.timestamps
    end
    
    drop_table :groups
    drop_table :query_filters
  end

  def self.down
    drop_table :content_filters
  end
end

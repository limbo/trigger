class CreateFilters < ActiveRecord::Migration
  def self.up
    create_table :filters do |t|
      t.string   "filter_name"
      t.string   "query"
      t.integer  "owner_id"
      t.timestamps
    end
  end

  def self.down
    drop_table :filters
  end
end

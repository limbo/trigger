class CreateGroupsTable < ActiveRecord::Migration
  def self.up
    create_table :groups, :force => true do |t|
      t.column 'group_name', :string
      t.column 'owner_id', :integer
      t.timestamps
    end
    
  end

  def self.down
    drop_table :groups
  end
end

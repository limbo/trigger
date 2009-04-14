class CreateUserGroupTable < ActiveRecord::Migration
  def self.up
    create_table :accounts_groups, :force => true, :id => false, :primary_key => [:account_id, :group_id] do |t|
      t.column 'account_id', :integer, :null => false
      t.column 'group_id', :integer, :null => false
      t.timestamps
    end
  end

  def self.down
    drop_table :accounts_groups
  end
end

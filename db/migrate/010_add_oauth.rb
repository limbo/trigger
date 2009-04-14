class AddOauth < ActiveRecord::Migration
  def self.up
    add_column :accounts, :token, :string
    add_column :accounts, :secret, :string
  end

  def self.down
    drop_column :accounts, :token
    drop_column :accounts, :secret
  end
end

class CreateAccountsTable < ActiveRecord::Migration
  def self.up
    create_table "accounts" do |t|
      t.column "owner_id", :integer
      t.column "remote_id", :integer
      t.column "login", :string
      t.column "password", :string
      t.column "last_msg_id", :integer
    end
  end

  def self.down
    drop_table "accounts"
  end
end

class AddProfileImageUrl < ActiveRecord::Migration
  def self.up
    add_column :accounts, :profile_image_url, :string
  end

  def self.down
    drop_column :accounts, :profile_image_url
  end
end

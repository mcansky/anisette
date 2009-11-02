class ToAuthlogic < ActiveRecord::Migration
  def self.up
		remove_column :users, :salt
    add_column :users, :password_salt, :string
		add_column :users, :persistence_token, :string
  end

  def self.down
		remove_column :users, :password_salt
		remove_column :users, :persistence_token
    add_column :users, :salt, :string
  end
end

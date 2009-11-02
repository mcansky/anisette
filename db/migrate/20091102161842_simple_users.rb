class SimpleUsers < ActiveRecord::Migration
  def self.up
		remove_column :users, :password_confirmation
		remove_column :users, :remember_token
		remove_column :users, :remember_token_expires_at
		remove_column :users, :username
		add_column :users, :login, :string
  end

  def self.down
		add_column :users, :password_confirmation, :string
		add_column :users, :remember_token, :string
		remove_column :users, :login
		add_column :users, :username, :string
		add_column :users, :remember_token_expires_at, :string
  end
end

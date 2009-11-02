class FrackinRestfullFuck < ActiveRecord::Migration
  def self.up
		add_column :users, :crypted_password, :string
		add_column :users, :remember_token, :string
  end

  def self.down
		remove_column :users, :crypted_password
		remove_column :users, :remember_token
		add_column :users, :crypted_password, :string, :limit => '40'
		add_column :users, :remember_token, :string, :limit => '40'
  end
end

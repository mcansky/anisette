class Authlogictweaks < ActiveRecord::Migration
  def self.up
		remove_column :users, :name
    add_column :users, :username, :string
  end

  def self.down
		remove_column :users, :username
    add_column :users, :name, :string
  end
end

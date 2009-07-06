class AddLocalIdToBug < ActiveRecord::Migration
  def self.up
    add_column :bugs, :local_id, :integer, :default => 0
  end

  def self.down
    remove_column :bugs, :local_id
  end
end

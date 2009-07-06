class AddBugFixIDdefault < ActiveRecord::Migration
  def self.up
    remove_column :bugs, :fix_id
    add_column :bugs, :fix_id, :integer, :default => 0
  end

  def self.down
    remove_column :bugs, :fix_id
    add_column :bugs, :fix_id, :integer
  end
end

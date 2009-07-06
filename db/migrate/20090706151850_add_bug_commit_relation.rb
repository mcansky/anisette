class AddBugCommitRelation < ActiveRecord::Migration
  def self.up
    add_column :bugs, :fix_id, :integer
  end

  def self.down
    remove_column :bugs, :fix_id
  end
end

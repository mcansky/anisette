class AddCommitTime < ActiveRecord::Migration
  def self.up
    add_column :anisette_commits, :commited_time, :date
  end

  def self.down
    remove_column :anisette_commits, :commited_time
  end
end

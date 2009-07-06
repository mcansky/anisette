class ChangeCommitTime < ActiveRecord::Migration
  def self.up
    remove_column :anisette_commits, :commited_time
    add_column :anisette_commits, :commited_time, :datetime
  end

  def self.down
    remove_column :anisette_commits, :commited_time
    add_column :anisette_commits, :commited_time, :date
  end
end

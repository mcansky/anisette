class ChangeCommitTable < ActiveRecord::Migration
  def self.up
    drop_table :commits
    create_table :anisette_commits do |t|
      t.string :sha
      t.text  :log
      t.integer :branch_id
      t.integer :author_id
      t.string  :author_name
      t.timestamps
    end
  end

  def self.down
    drop_table :anisette_commits
    create_table :commits do |t|
      t.string :sha
      t.text  :log
      t.integer :branch_id
      t.integer :author_id
      t.string  :author_name
      t.timestamps
    end
  end
end

class MoveToBranch < ActiveRecord::Migration
  def self.up
		add_column :events, :branch_id, :integer
  end

  def self.down
		remove_column :events, :branch_id
  end
end

class ChangeType < ActiveRecord::Migration
  def self.up
    remove_column :events, :type
    add_column :events, :event_type, :integer
  end

  def self.down
    remove_column :events, :event_type
    add_column :events, :type, :integer
  end
end

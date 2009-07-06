class CreateEvents < ActiveRecord::Migration
  def self.up
    create_table :events do |t|
      t.column :type, :integer
      t.column :event_id, :integer
      t.column :repository_id, :integer
      t.timestamps
    end
  end

  def self.down
    drop_table :events
  end
end

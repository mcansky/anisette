class AddAuthorInfoInBugs < ActiveRecord::Migration
  def self.up
    add_column :bugs, :author_id, :integer
  end

  def self.down
    remove_column :bugs, :author_id
  end
end

class ChangeRepositoryRepcol < ActiveRecord::Migration
  def self.up
    remove_column :repositories, :repository_id
    add_column :repositories, :project_id, :integer 
  end

  def self.down
    remove_column :repositories, :project_id
    add_column :repositories, :repository_id, :integer 
  end
end

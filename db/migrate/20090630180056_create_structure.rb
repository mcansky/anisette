class CreateStructure < ActiveRecord::Migration
  def self.up
    create_table :projects do |t|
      t.string :name
      t.text :desc
      t.integer :owner_id
      t.timestamps
    end
    create_table :repositories do |t|
      t.string :name
      t.string :path
      t.integer :owner_id
      t.integer :repository_id
      t.timestamps
    end
    create_table :branches do |t|
      t.string :name
      t.integer :repository_id
      t.integer :owner_id
      t.timestamps
    end
    create_table :commits do |t|
      t.string :sha
      t.text  :log
      t.integer :branch_id
      t.integer :author_id
      t.string  :author_name
      t.timestamps
    end
    create_table :bugs do |t|
      t.string :title
      t.text :desc
      t.integer :repository_id
      t.integer :branch_id
      t.string :state
      t.timestamps
    end
    create_table :users do |t|
      t.string :login
      t.string :password
      t.string :email
    end
    create_table :talks do |t|
      t.string :title
      t.text :text
      t.integer :parent_id, :default => 0
      t.integer :bug_id
      t.integer :commit_id
      t.string  :action
      t.string  :author_id
      t.timestamps
    end

    create_table :projects_users, :id => false do |t|
      t.integer :project_id
      t.integer :user_id
    end

    

  end

  def self.down
    drop_table :projects
    drop_table :repositories
    drop_table :branches
    drop_table :commits
    drop_table :bugs
    drop_table :users
    drop_table :projects_users
    drop_table :talks
  end
end

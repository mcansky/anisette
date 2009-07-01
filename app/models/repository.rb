class Repository < ActiveRecord::Base
  belongs_to :project
  has_many :branches
  has_many :bugs
  has_many :commits, :through => :branches, :class_name => "AnisetteCommit" 
end

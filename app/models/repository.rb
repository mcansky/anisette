class Repository < ActiveRecord::Base
  belongs_to :project
  has_many :branches
  has_many :bugs
  has_many :commits, :through => :branches, :class_name => "AnisetteCommit", :order => "commited_time"
  has_many :events
  belongs_to :owner, :foreign_key => "owner_id", :class_name => "User"

  validates_presence_of     :path
  validates_presence_of     :name

end

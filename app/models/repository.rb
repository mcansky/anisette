require 'grit'
include Grit

class Repository < ActiveRecord::Base
  belongs_to :project
  has_many :branches
  has_many :bugs, :through => :branches
  has_many :open_bugs, :through => :branches, :class_name => "Bug", :conditions => "fix_id = 0"
  has_many :fixed_bugs, :through => :branches, :class_name => "Bug", :conditions => "fix_id != 0"
  has_many :commits, :through => :branches, :class_name => "AnisetteCommit", :order => "commited_time"
  has_many :events, :through => :branches
  belongs_to :owner, :foreign_key => "owner_id", :class_name => "User"

  validates_presence_of     :path
  validates_presence_of     :name

	def update
		foo_rep = Repo.new(self.path)
		foo_rep.branches.each do |b|
			if not self.branches.find_by_name(b.name)
				self.branches << Branch.new(:name => b.name)
			end
		end
		self.branches.each { |b| b.update }
	end

	def purge
		self.branches.each do |b|
			b.purge
			b.destroy
		end
	end

end

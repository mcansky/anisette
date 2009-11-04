class Repository < ActiveRecord::Base
  belongs_to :project
  has_many :branches
  has_many :bugs, :throught => :branches
  has_many :open_bugs, :throught => :branches, :class_name => "Bug", :conditions => "fix_id = 0"
  has_many :fixed_bugs, :throught => :branches, :class_name => "Bug", :conditions => "fix_id != 0"
  has_many :commits, :through => :branches, :class_name => "AnisetteCommit", :order => "commited_time"
  has_many :events, :throught => :branches
  belongs_to :owner, :foreign_key => "owner_id", :class_name => "User"

  validates_presence_of     :path
  validates_presence_of     :name

	def update
		repo = Repo.new(self.path)
		repo.branches.each do |b|
			if not self.branches.find_by_name(b.name)
				self.branches << Branch.new(:name => b.name)
				self.save
			end
			a_branch = self.branches.find_by_name(b.name)
			repo.commits(b.name, 100) do |c|
				a_commit = AnisetteCommit.new(:sha => c.id,
                                          :log => c.message,
                                          :author_name => c.author.name,
                                          :created_at => c.committed_date,
                                          :commited_time => c.committed_date)
				a_branch.commits << a_commit
				a_commit.save
				# add the corresponding event
				e = Event.new(:event_id => a_commit.id)
				e.event_type = 0
				e.save
				a_commit.branch.repository.events << e
				# check for fixes in commit message
				bugs_ids = []
				a_msg = c.message
				# parsing for bug fixes
				pattern = /\s*(fix|fixes|close)\s#([0-9]+)/
				while ( pattern =~ a_msg ) do
					a_msg.slice!(Regexp.last_match[0])
					bugs_ids << Regexp.last_match[2]
				end
				# adding bugs in the commit fixed array
				bugs_ids.each do |b_id|
					if ((b = a_repository.bugs.find(:all, :conditions => "local_id = #{b_id}")) && b.count > 0)
						a_bug = b.first
						if !(a_bug.fixed?)
							a_commit.fixed_bugs << a_bug
							a_commit.save
						end
					end
				end
			end
			a_branch.save
		end
	end
	
	def purge
		self.branches.each do |b|
			b.commits.each { |c| c.destroy }
			b.destroy
		end
	end
	
	def add_event(an_event)
		e = Event.new(:event_id => an_event.id)
		if e.class == "AnisetteComit"
			e.event_type = 0
		end
		self.events << e
		self.save
	end
	
end

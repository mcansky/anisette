class Branch < ActiveRecord::Base
  belongs_to :repository
	has_many :bugs
  has_many :open_bugs, :class_name => "Bug", :conditions => "fix_id = 0"
  has_many :fixed_bugs, :class_name => "Bug", :conditions => "fix_id != 0"
  has_many :commits, :class_name => "AnisetteCommit", :order => "commited_time"
	has_many :events

	def add_event(an_event)
		e = Event.new(:event_id => an_event.id)
		if e.class == "AnisetteComit"
			e.event_type = 0
		end
		self.events << e
		self.save
	end
	
	def purge
		self.commits.each { |c| c.destroy }
	end
	
	def update
		foo_rep = Repo.new(self.repository.path)
		new_commits_count = foo_rep.commit_count(self.name) - self.commits.count
		commits = foo_rep.commits(self.name, new_commits_count)
	end
end

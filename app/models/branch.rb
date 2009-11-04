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
		count = 0
		while (count < new_commits_count)
			commits = foo_rep.commits(self.name, 10, count)
			commits.each do |c|
				if (not AnisetteCommit.find_by_sha(c.id))
					a_commit = AnisetteCommit.new(:sha => c.id,
						:log => c.message,
						:author_name => c.author.name,
						:created_at => c.committed_date,
						:commited_time => c.committed_date)
					self.commits << a_commit
				end
			end
			diff_c = new_commits_count - count
			if (diff_c > 10)
				count += 10
			else
				count += diff_c
			end
		end
	end

end

class Project < ActiveRecord::Base
  has_many :repositories
  belongs_to :owner, :class_name => "User", :foreign_key => "owner_id"

  def stats
    c_count = 0;
    b_count = 0;
    r_count = 0;
    r_count = self.repositories.count
    self.repositories.each do |r|
      b_count += r.branches.count
      c_count += r.commits.count
    end
    stats = "#{c_count} commits in #{b_count} branches in #{r_count} repositories"
  end
	
	def update
		self.repositories.each { |r| r.update }
	end

end

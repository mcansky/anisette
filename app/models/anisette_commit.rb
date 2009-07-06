class AnisetteCommit < ActiveRecord::Base
  belongs_to :branch
  belongs_to :author, :class_name => "User", :foreign_key => "author_id"
  has_many :fixed_bugs, :class_name => "Bug", :foreign_key => "fix_id"

  def short_sha
    sha_size = self.sha.size
    s_max = sha_size - 0
    s_6max = sha_size - 8
    short_sha = self.sha[0,8] + "......" + self.sha[s_6max,s_max]
    return short_sha
  end

  def get_diffs
    grit_repo = Repo.new(self.branch.repository.path)
    found = false
    seen_all = false
    grit_commit = nil
    grit_commit = grit_repo.commits(self.branch.name, 1000).find { |c| c.id == self.sha }
    if (!grit_commit)
      return []
    else
      return grit_commit.diffs
    end
  end

  def short_log
    if (self.log.size < 42)
      return self.log
    else
      return self.log[0,42] + " ..."
    end
  end

  def check_and_set_author
    if (self.author == nil)
      u_name = ''
      begin
        u_name = User.find_by_login(self.author_name)
        u_name.commits << self
        return true
      rescue
        u_name = ''
      end
      return false
    end
    return true
  end

end

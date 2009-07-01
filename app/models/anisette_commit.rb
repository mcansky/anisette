class AnisetteCommit < ActiveRecord::Base
  belongs_to :branch

  def short_sha
    sha_size = self.sha.size
    s_max = sha_size - 0
    s_6max = sha_size - 8
    short_sha = self.sha[0,8] + "......" + self.sha[s_6max,s_max]
    return short_sha
  end

  def short_log
    if (self.log.size < 42)
      return self.log
    else
      return self.log[0,42] + " ..."
    end
  end

end

class Bug < ActiveRecord::Base
  belongs_to :author, :class_name => "User", :foreign_key => "author_id"
  belongs_to :fixing_commit, :class_name => "AnisetteCommit", :foreign_key => "fix_id"
  belongs_to :repository

  def short_desc
    if (self.desc.size < 42)
      return self.desc
    else
      return self.desc[0,42] + " ..."
    end
  end

  def fixed?
    if self.fixing_commit != nil
      return true
    end
    return false
  end

end

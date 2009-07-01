class Bug < ActiveRecord::Base
  belongs_to :author, :class_name => "User", :foreign_key => "author_id"
  belongs_to :repository

  def short_desc
    if (self.desc.size < 42)
      return self.desc
    else
      return self.desc[0,42] + " ..."
    end
  end

end

class Branch < ActiveRecord::Base
  belongs_to :repository
  has_many :commits, :class_name => "AnisetteCommit", :order => "commited_time"
end

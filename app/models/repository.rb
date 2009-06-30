class Repository < ActiveRecord::Base
  belongs_to :project
  has_many :branches
end

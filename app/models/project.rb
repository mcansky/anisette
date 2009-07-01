class Project < ActiveRecord::Base
  has_many :repositories
  belongs_to :owner, :class_name => "User", :foreign_key => "owner_id"
end

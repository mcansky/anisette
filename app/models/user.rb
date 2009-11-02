require 'digest/sha1'

class User < ActiveRecord::Base
  has_many :commits, :class_name => "AnisetteCommit", :foreign_key => "author_id"
  has_many :projects, :foreign_key => "owner_id"
  has_many :bugs, :foreign_key => "author_id"
  has_many :repositories, :foreign_key => "owner_id"

end

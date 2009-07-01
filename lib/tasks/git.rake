require 'grit'
include Grit

namespace :git do
  desc "check git dep for new commits"
  task(:pull => :environment) do
    projects = Project.find(:all)
    projects.each do |a_project|
      a_project.repositories.each do |a_repository|
        repo = Repo.new(a_repository.path)
        repo.branches.each do |b|
          if not (a_repository.branches.find_by_name(b.name))
            a_repository.branches << Branch.new(:name => b.name)
            a_repository.save
          end
          a_branch = a_repository.branches.find_by_name(b.name)
          repo.commits(b.name,100).each do |c|
            if not (a_branch.commits.find_by_sha(c.id))
              a_commit = AnisetteCommit.new(:sha => c.id,
                                          :log => c.message,
                                          :author_name => c.author.name,
                                          :commited_time => c.committed_date)
              a_branch.commits << a_commit
              a_commit.save
              # add the corresponding event
              e = Event.new(:event_id => a_commit.id)
              e.event_type = 0
              e.save
              a_commit.branch.repository.events << e
              # check for fixes in commit message
              bugs_ids = []
              a_msg = c.message
              pattern = /\s(fix|fixes|close)\s#([0-9]+)/
              #while ( pattern =~ a_msg ) do
                #bugs_ids << a_msg.slice!(Regexp.last_match[3])
              #end
            end
          end
          a_branch.save
        end
      end
    end
  end

  desc "Purge commits DB !!"
  task(:purge => :environment) do
    projects = Project.find(:all)
    projects.each do |a_project|
      a_project.repositories.each do |r|
        r.branches.each do |b|
          b.commits.each do |c|
            c.destroy
          end
          b.destroy
        end
      end
    end
  end

end

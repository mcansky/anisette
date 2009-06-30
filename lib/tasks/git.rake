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
            a_commit = AnisetteCommit.new(:sha => c.id,
                                          :log => c.message,
                                          :author_name => c.author.name,
                                          :commited_time => c.committed_date)
            if not (a_branch.commits.find_by_sha(a_commit.sha))
              a_branch.commits << a_commit
            end
          end
          a_branch.save
        end
      end
    end
  end

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

require 'grit'
include Grit

namespace :git do
  desc "check git dep for new commits"
  task(:pull => :environment) do
    projects = []
    project_name = ENV['PNAME']
    case
      when project_name == 'all'
        projects = Project.find(:all)
      else
        projects << Project.find_by_name(project_name)
    end
    projects.each do |a_project|
      printf("Treating #{a_project.name}\n")
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
                                          :created_at => c.committed_date,
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
              # parsing for bug fixes
              pattern = /\s*(fix|fixes|close)\s#([0-9]+)/
              while ( pattern =~ a_msg ) do
                a_msg.slice!(Regexp.last_match[0])
                bugs_ids << Regexp.last_match[2]
              end
              # adding bugs in the commit fixed array
              bugs_ids.each do |b_id|
                if ((b = a_repository.bugs.find(:all, :conditions => "local_id = #{b_id}")) && b.count > 0)
                  a_bug = b.first
                  if !(a_bug.fixed?)
                    a_commit.fixed_bugs << a_bug
                    a_commit.save
                  end
                end
              end
              # parsing for bug refs (for future implementation)
              #refs_ids = []
              #a_msg = c.message
              #pattern = /\s*(ref|refs|link)\s#([0-9]+)/
              #while ( pattern =~ a_msg ) do
              #  a_msg.slice!(Regexp.last_match[0])
              #  refs_ids << Regexp.last_match[2]
              #end
              #bugs_ids.each do |b_id|
              #  if (b = a_repository.bugs.find(:all, :conditions => "local_id = #{b_id}")
              #    a_commit.bugs_refs << b
              #    a_commit.save
              #  end
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
    projects = []
    project_name = ENV['PNAME']
    case
      when project_name == 'all'
        projects = Project.find(:all)
      else
        projects << Project.find_by_name(project_name)
    end
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

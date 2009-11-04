require 'grit'
include Grit

def treat_commit(a_repository, a_branch,c)
	# check for fixes in commit message
	bugs_ids = []
	a_msg = c.log
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
	return a_commit
end

def treat_branch(git_repo, a_repository, a_branch)
	puts "treat branch"
	i = 0
  git_repo.commits(a_branch.name,60).each do |c|
		puts "checking the commits #{i}"
		if not AnisetteCommit.find_by_sha(c.id)
			puts "passed find sha #{i}"	
			a_commit = AnisetteCommit.new(:sha => c.id,
				:log => c.message,
				:author_name => c.author.name,
				:created_at => c.committed_date,
				:commited_time => c.committed_date)
			puts "created commit #{i}"
			a_branch.add_event(c)
			#a_branch.commits << treat_commit(a_repository, a_branch, a_commit)
		end
		i+=1
	end
  return a_branch
end

namespace :git do
  desc "check git dep for new commits"
  task(:pull => :environment) do
    projects = []
		if (ENV['PNAME'])
			project_name = ENV['PNAME']
			projects << Project.find_by_name(project_name)
		else
			projects = Project.find(:all)
		end
    projects.each do |a_project|
      printf ("Treating #{a_project.name} : ")
			a_project.update
			a_project.save
			printf ("ok\n")
    end
  end

  desc "Purge commits DB !!"
  task(:purge => :environment) do
    projects = []
    if (ENV['PNAME'])
			project_name = ENV['PNAME']
			projects << Project.find_by_name(project_name)
		else
			projects = Project.find(:all)
		end
    projects.each do |a_project|
			printf ("Purging #{a_project.name} : ")
      a_project.repositories.each do |r|
				r.purge
      end
			printf ("ok\n")
    end
  end

end

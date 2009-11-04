# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
		# return an stats array (using the AnisetteCommit.stats method)
	# n_day is the numbers of days ago you want stats from (1 gives you today)
	# repo_id is the repository id
	def day_stats(a_day, project_id, repo_id)
		if (project_id == nil)
			return nil
		end
		if (a_day == nil)
			a_day = 1
		end
		a_p = Project.find(project_id)
		if (repo_id == nil)
			active_repo = a_p.repositories[0]
		else
			active_repo = a_p.repositories.find(repo_id)
		end
		day_stats = { 'files' => 0, 'subs' => 0, 'adds' => 0, 'commits' => 0 }
		if (a_day > 1)
			conditions = ['commited_time > ? && commited_time < ?', a_day.day.ago, (a_day-1).day.ago]
		else
			conditions = ['commited_time > ?', 1.day.ago]
		end
		active_repo.commits.find(:all, :conditions => conditions).each do |c|
			stats = quick_stats(c.stats.files)
			day_stats['files'] += stats['files']
			day_stats['subs'] += stats['subs']
			day_stats['adds'] += stats['adds']
			day_stats['commits'] += 1
		end
		return day_stats
	end
	
  def quick_stats(commit_files)
    stats = Hash.new()
    stats['adds'] = 0
    stats['subs'] = 0
    stats['files'] = 0
    stats['files'] = commit_files.count
    commit_files.each do |f|
      stats['adds'] += f[1]
      stats['subs'] += f[2]
    end
    return stats
  end

end

# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
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

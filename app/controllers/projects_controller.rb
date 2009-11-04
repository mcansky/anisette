class ProjectsController < ApplicationController

  def new
    if (current_user)
      @project = Project.new
    else
        flash[:notice] = "You need to login"
        redirect_to "/login"
    end
  end

  def create
    @project = Project.new(params[:project])
    session[:repository_id] = nil
    current_user.projects << @project
    success = @project && @project.save
    if success && @project.errors.empty?
      redirect_to ("/projects/get/#{@project.id}")
      flash[:notice] = "new Project added !"
    else
      flash[:error]  = "We couldn't set up the project, sorry.  Please try again, or contact an admin (link is above)."
      render :action => 'new'
    end
  end

  def index
    @projects = Project.find(:all)
    session[:repository_id] = nil
  end

  def get
    @project = Project.find(params[:id])
    session[:project_id] = @project.id
    if (@project.repositories.size > 0)
			if (@project.repositories.find_by_name('origin') != nil)
				if (session[:repository_id] and Repository.find(session[:repository_id]))
					active_repo = Repository.find(session[:repository_id])
				else
					active_repo = @project.repositories.find_by_name('origin')
				end
			else
				active_repo = @project.repositories[0]
			end
			session[:repository_id] = active_repo.id
			
			# stats
			@commits = active_repo.commits
			@today_stats = { 'files' => 0, 'subs' => 0, 'adds' => 0 }
			@commits.find(:all, :conditions => ['commited_time > ?', 1.day.ago]).each do |c|
				stats = quick_stats(c.stats.files)
				@today_stats['files'] += stats['files']
				@today_stats['subs'] += stats['subs']
				@today_stats['adds'] += stats['adds']
			end
			
			events = []
      active_repo.commits.reverse.each { |c| events << c }
      active_repo.bugs.reverse.each { |b| events << b }
      events.sort! { |a,b| a.created_at <=> b.created_at }
      @events = events.reverse
			# pagination
			a_page = 1
			a_ppage = 10
			if (params[:page] != nil)
				a_page = params[:page]
			end
			if (params[:per_page] != nil)
				a_ppage = params[:per_page] || 10
			end
			options = {:page => a_page, :per_page => a_ppage}
			@page_results = @events.paginate(options)
    else
      session[:repository_id] = nil
			@events = []
			@page_results = []
    end
    render :layout => 'project'
  end

  def branch
    @project = Project.find(session[:project_id])
    branch = Branch.find(params[:id])
    if (session[:repository_id])
      active_repo = @project.repositories.find(session[:repository_id])
    else
      active_repo = @project.repositories.find_by_name('origin')
    end
    events = []
    branch.commits.last(10).reverse.each { |c| events << c }
    branch.repository.bugs.last(10).reverse.each { |b| events << b }
    events.sort! { |a,b| a.created_at <=> b.created_at }
    @events = events.reverse
		# pagination
		a_page = 1
		a_ppage = 10
		if (params[:page] != nil)
			a_page = params[:page]
		end
		if (params[:per_page] != nil)
			a_ppage = params[:per_page] || 10
		end
		options = {:page => a_page, :per_page => a_ppage}
		@page_results = @events.paginate(options)
    render :partial => 'lately'
  end

	private
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

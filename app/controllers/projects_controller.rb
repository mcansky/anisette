class ProjectsController < ApplicationController

  def new
    if (logged_in?)
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
      redirect_back_or_default("/projects/get/#{@project.id}")
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
      if (session[:repository_id])
        active_repo = @project.repositories.find(session[:repository_id])
      else
        active_repo = @project.repositories.find_by_name('origin')
      end
      session[:repository_id] = active_repo.id
      events = []
      active_repo.commits.last(10).reverse.each { |c| events << c }
      active_repo.bugs.last(10).reverse.each { |b| events << b }
      events.sort! { |a,b| a.created_at <=> b.created_at }
      @events = events.reverse
    else
      session[:repository_id] = nil
			@events = []
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
    render :partial => 'lately'
  end



end

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
    logout_keeping_session!
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
  end

  def get
    @project = Project.find(params[:id])
    session[:project_id] = @project.id
    if ((not session[:repository_id]) && (@project.repositories.size > 0))
      session[:repository_id] = @project.repositories.find_by_name('origin')
    else
      session[:repository_id] = nil
    end
    render :layout => 'project'
  end
end

class BugsController < ApplicationController

  def new
    if (logged_in?)
      @bug = Bug.new
      @project = Project.find(session[:project_id])
    else
        flash[:notice] = "You need to login"
        redirect_to "/login"
    end
    render :layout => 'project'
  end

  def create
    @bug = Bug.new(params[:bug])
    if (session[:repository_id])
      @bug.repository_id = session[:repository_id]
    else
      @bug.repository_id = Project.find(session[:project_id]).repositories.find_by_name('origin').id
    end
    r_id = @bug.repository_id
    success = @bug && @bug.save
    if success && @bug.errors.empty?
      redirect_to("/projects/get/#{session[:project_id]}")
      flash[:notice] = "Thanks for reporting !"
    else
      flash[:notice] = "We couldn't set up the bug report, sorry. Please try again or contact admin"
      render :action => 'new'
    end
  end

  def get
    if (params[:id])
      @bug = Bug.find(params[:id])
      @project = @bug.repository.project
    elsif (session[:project_id])
      @project = Project.find(session[:project_id])
    end
    render :layout => 'project'
  end

  def show
    @bug = Bug.find(params[:id])
    @project = @bug.repository.project
    render :layout => 'project'
  end
end
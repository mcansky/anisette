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
    if (@bug.repository.bugs.size > 0)
      @bug.local_id = @bug.repository.bugs.last.local_id + 1
    else
      @bug.local_id = 1
    end
    current_user.bugs << @bug
    success = @bug && @bug.save
    if success && @bug.errors.empty?
      e = Event.new(:event_id => @bug.id)
      e.event_type = 1
      e.save
      @bug.repository.events << e
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

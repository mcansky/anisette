class ProjectsController < ApplicationController
  def index
    @projects = Project.find(:all)
  end

  def get
    @project = Project.find(params[:id])
    session[:project_id] = @project.id
    render :layout => 'project'
  end
end

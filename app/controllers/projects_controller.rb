class ProjectsController < ApplicationController
  def index
    @projects = Project.find(:all)
  end

  def get
    @project = Project.find(params[:id])
    render :layout => 'project'
  end
end

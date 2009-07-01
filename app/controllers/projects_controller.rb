class ProjectsController < ApplicationController
  def index
    @projects = Project.find(:all)
    render :layout => 'project'
  end

  def index
    @project = Project.find()
    render :layout => 'project'
  end
end

class ProjectController < ApplicationController
  def index
    @project = Project.find(:all).first
    render :layout => 'application'
  end
end

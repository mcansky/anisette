class BaseController < ApplicationController
  def index
    @project = Project.find(:all).first
  end

end

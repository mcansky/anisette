class RepositoriesController < ApplicationController
  def new
    if (logged_in?)
      @repository = Repository.new
    else
        flash[:notice] = "You need to login"
        redirect_to "/login"
    end
  end

  def create
    if (not logged_in?)
      redirect_to "/login"
    end
    @repository = Repository.new(params[:repository])
    @repository.project_id = session[:project_id]
    session[:repository_id] = nil
    success = @repository && @repository.save
    if success && @repository.errors.empty?
      current_user.repositories << @repository
      redirect_back_or_default("/projects/get/#{@repository.project_id}")
      flash[:notice] = "new Repository added !"
    else
      flash[:error]  = "We couldn't set up the repository, sorry.  Please try again, or contact an admin (link is above)."
      render :action => 'new'
    end
  end
end

class RepositoriesController < ApplicationController
  def new
    if (current_user)
      @repository = Repository.new
    else
        flash[:notice] = "You need to login"
        redirect_to "/login"
    end
  end

  def create
    if (not current_user)
      redirect_to "/login"
    end
    @repository = Repository.new(params[:repository])
    @repository.project_id = session[:project_id]
    session[:repository_id] = nil
    success = @repository && @repository.save
    if success && @repository.errors.empty?
      current_user.repositories << @repository
      redirect_to("/projects/get/#{@repository.project_id}")
      flash[:notice] = "new Repository added !"
    else
      flash[:error]  = "We couldn't set up the repository, sorry.  Please try again, or contact an admin (link is above)."
      render :action => 'new'
    end
  end
	
	def update
		if (not current_user)
			redirect_to "/login"
		end
		@repository = Repository.find(params[:id])
		@repository.update
		session[:repository_id] = @repository.id
		events = []
		@repository.commits.reverse.each { |c| events << c }
		@repository.bugs.reverse.each { |b| events << b }
		events.sort! { |a,b| a.created_at <=> b.created_at }
		@events = events.reverse
		# pagination
		a_page = 1
		a_ppage = 10
		if (params[:page] != nil)
			a_page = params[:page]
		end
		if (params[:per_page] != nil)
			a_ppage = params[:per_page] || 10
		end
		options = {:page => a_page, :per_page => a_ppage}
		@page_results = @events.paginate(options)
		render :partial => 'projects/lately'
	end

	def purge
		if (not current_user)
			redirect_to "/login"
		end
		Repository.find(params[:id]).purge
		render :text => "Empty"
	end
end

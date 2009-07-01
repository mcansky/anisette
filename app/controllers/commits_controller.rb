class CommitsController < ApplicationController

  def get
    @commit = AnisetteCommit.find(params[:id])
    @project = @commit.branch.repository.project
    render :layout => 'project'
  end
end

class CommitsController < ApplicationController

  def get
    @commit = AnisetteCommit.find(params[:id])
    @commit.check_and_set_author
    @project = @commit.branch.repository.project
    render :layout => 'project'
  end
end

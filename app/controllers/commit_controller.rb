class CommitController < ApplicationController

  def get
    @commit = AnisetteCommit.find(params[:id])
    @project = @commit.branch.repository.project
  end

end

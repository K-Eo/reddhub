class Pods::CommentsController < CommentsController
  before_action :set_commentable

  private

    def set_commentable
      @commentable = Pod.find(params[:pod_id])
    end
end

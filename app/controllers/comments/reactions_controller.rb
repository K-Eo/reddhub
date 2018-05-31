class Comments::ReactionsController < ReactionsController
  before_action :set_reactable

  private

    def set_reactable
      @reactable = Comment.find(params[:comment_id])
    end
end

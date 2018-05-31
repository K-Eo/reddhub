class CommentsController < ApplicationController
  before_action :authenticate_user!

  def create
    @comment = @commentable.comments.new comment_params
    @comment.user = current_user
    if @comment.save
      redirect_to user_pod_path(@commentable.user.username, @commentable), notice: t(".notice")
    else
      @user = @commentable.user
      @pod = @commentable
      render template: "profiles/pods/show", layout: "home"
    end
  end

  private

    def comment_params
      params.require(:comment).permit(:body)
    end
end

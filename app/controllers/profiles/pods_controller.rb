class Profiles::PodsController < ApplicationController
  before_action :set_user_by_username
  layout "home"

  def show
    @pod = @user.pods.no_deleted.find(params[:id])
    @comments = @pod.comments.newest.includes(user: [{ avatar_attachment: :blob }]).page(params[:page])
    @reactions = current_user.reactions_for(@comments, "Comment")

    if @pod.story?
      render template: "profiles/stories/show", layout: "empty"
    else
      render
    end
  end
end

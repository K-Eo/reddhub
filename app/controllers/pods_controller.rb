class PodsController < ApplicationController
  before_action :authenticate_user!

  def create
    @pod = current_user.pods.new(pod_params)

    respond_to do |format|
      if @pod.save
        format.html { redirect_to root_path(current_user.username), notice: "Pod was successfully created." }
        format.js
      else
        format.html do
          @user = current_user
          @pods = current_user.feed.page(params[:page])
          @reactions = current_user.reactions_for(@pods, "Pod")
          render template: "home/show", layout: "home"
        end
        format.js
      end
    end
  end

  private

    def pod_params
      params.require(:pod).permit(:content)
    end
end

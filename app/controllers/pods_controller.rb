class PodsController < ApplicationController
  before_action :authenticate_user!

  def create
    @pod = current_user.pods.new(pod_params)

    if @pod.save
      redirect_to root_path(current_user.username), notice: t(".notice")
    else
      @user = current_user
      @pods = current_user.feed.page(params[:page])
      @reactions = current_user.reactions_for(@pods, "Pod")
      flash.now[:alert] = t(".alert")
      render template: "home/show", layout: "home"
    end
  end

  def destroy
    @pod = current_user.pods.find(params[:id])
    @pod.purge
    redirect_to root_path, notice: "Pod was successfully deleted."
  end

  private

    def pod_params
      params.require(:pod).permit(:content)
    end
end

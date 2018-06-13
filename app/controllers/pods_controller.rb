class PodsController < ApplicationController
  before_action :authenticate_user!

  def create
    @pod = current_user.pods.new(pod_params)

    respond_to do |format|
      if @pod.save
        format.html do
          redirect_to root_path(current_user.username), notice: t(".notice")
        end
        format.json { render @pod, status: :ok }
      else
        format.html do
          @user = current_user
          @pods = current_user.feed.page(params[:page])
          @reactions = current_user.reactions_for(@pods, "Pod")
          flash.now[:alert] = t(".alert")
          render template: "home/show", layout: "home"
        end
        format.json { render json: @pod.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @pod = current_user.pods.find(params[:id])
    @pod.purge
    redirect_to root_path, notice: t(".notice")
  end

  private

    def pod_params
      params.require(:pod).permit(:content)
    end
end

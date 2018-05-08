class PodsController < ApplicationController
  def create
    @pod = current_user.pods.new(pod_params)

    if @pod.save
      redirect_to user_path(current_user.username), notice: "Pod has been created."
    else
      redirect_to user_path(current_user.username), danger: "Pod can't be created."
    end
  end

  private

    def pod_params
      params.require(:pod).permit(:content)
    end
end

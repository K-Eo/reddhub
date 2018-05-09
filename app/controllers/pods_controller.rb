class PodsController < ApplicationController
  before_action :authenticate_user!

  def create
    @pod = current_user.pods.new(pod_params)

    respond_to do |format|
      if @pod.save
        format.html { redirect_to user_path(current_user.username), notice: "Pod has been created." }
        format.js
      else
        format.html { redirect_to user_path(current_user.username), danger: "Pod can't be created." }
        format.js
      end
    end
  end

  private

    def pod_params
      params.require(:pod).permit(:content)
    end
end

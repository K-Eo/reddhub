class Pods::AttachmentsController < ApplicationController
  before_action :authenticate_user!

  def create
    @pod = current_user.pods.find(params[:pod_id])
    pod_attachment = PodAttachment.new(attachments_params)

    respond_to do |format|
      if pod_attachment.attach_to(@pod)
        format.html { redirect_to user_pod_path(current_user.username, @pod) }
        format.json { render @pod, status: :ok }
      else
        format.html { redirect_to root_path }
        format.json { render @pod, status: :unprocessable_entity }
      end
    end
  end

  private

    def attachments_params
      params.require(:pod_attachment).permit(:image)
    end
end

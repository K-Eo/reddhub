class DestroyPodJob < ApplicationJob
  queue_as :default

  discard_on ActiveRecord::RecordNotFound

  def perform(pod_id)
    pod = Pod.find(pod_id)

    return unless pod.pending_delete

    pod.comments.find_each do |comment|
      comment.destroy
    end

    pod.images.purge

    pod.destroy
  end
end

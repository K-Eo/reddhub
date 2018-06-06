class DestroyPodJob < ApplicationJob
  queue_as :default

  discard_on ActiveRecord::RecordNotFound

  def perform(pod_id)
    pod = Pod.find(pod_id)
    pod.comments.find_each do |comment|
      comment.destroy
    end
    pod.destroy
  end
end

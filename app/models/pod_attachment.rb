class PodAttachment
  include ActiveModel::Model
  attr_accessor :image

  def attach_to(pod)
    if valid?
      pod.images.attach(image)
      true
    else
      false
    end
  end
end

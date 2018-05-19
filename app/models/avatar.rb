class Avatar
  include ActiveModel::Model
  attr_accessor :image

  validates :image, presence: true

  def attach(user)
    if valid?
      user.original.attach(image)
      true
    else
      false
    end
  end
end

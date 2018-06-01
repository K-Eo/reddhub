class Cover
  include ActiveModel::Model
  attr_accessor :image

  validates :image, presence: true

  def attach(user)
    if valid?
      user.cover.attach(image)
      true
    else
      false
    end
  end
end

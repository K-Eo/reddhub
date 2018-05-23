class Pod < ApplicationRecord
  belongs_to :user, counter_cache: true
  has_many :likes, as: :likeable
  has_many :comments, as: :commentable

  validates :content, presence: true,
                      length: { maximum: 256 }

  scope :newest, -> { order(created_at: :desc) }

  def liked_by(user)
    likes.where(user: user).first_or_create
  end

  def unliked_by(user)
    likes.where(user: user).destroy_all
  end
end

class Pod < ApplicationRecord
  belongs_to :user, counter_cache: true
  has_many :comments, as: :commentable
  has_many :reactions, as: :reactable

  validates :content, presence: true,
                      length: { maximum: 256 }

  scope :newest, -> { order(created_at: :desc) }
end

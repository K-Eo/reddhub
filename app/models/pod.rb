class Pod < ApplicationRecord
  include Likeable

  belongs_to :user, counter_cache: true
  has_many :comments, as: :commentable

  validates :content, presence: true,
                      length: { maximum: 256 }

  scope :newest, -> { order(created_at: :desc) }
end

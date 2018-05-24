class Comment < ApplicationRecord
  include Likeable

  belongs_to :commentable, polymorphic: true, counter_cache: true
  belongs_to :user

  validates :body, presence: true,
                   length: { maximum: 8000 }

  scope :newest, -> { order(created_at: :desc) }
end

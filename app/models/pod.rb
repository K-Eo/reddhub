class Pod < ApplicationRecord
  belongs_to :user

  validates :content, presence: true,
                      length: { maximum: 256 }

  scope :newest, -> { order(created_at: :desc) }
end

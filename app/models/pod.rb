class Pod < ApplicationRecord
  belongs_to :user

  validates :content, presence: true,
                      length: { maximum: 256 }
end

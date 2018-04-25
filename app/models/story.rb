class Story < ApplicationRecord
  belongs_to :user

  validates :title, presence: true,
                    length: { maximum: 60 }, on: :with_meta
  validates_presence_of :content, on: :with_content
end

class Story < ApplicationRecord
  validates :title, presence: true,
                    length: { maximum: 60 }
  validates_presence_of :content
end

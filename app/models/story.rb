class Story < ApplicationRecord
  belongs_to :user

  validates :title, presence: true,
                    length: { maximum: 60 }, on: :with_meta
  validates_presence_of :content, on: :with_content

  state_machine :state, initial: :draft do
    event :publish do
      transition :draft => :published
    end

    event :unpublish do
      transition :published => :draft
    end

    state :published
    state :draft
  end
end

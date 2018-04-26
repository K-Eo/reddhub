class Story < ApplicationRecord
  belongs_to :user

  validates :title, presence: true,
                    length: { maximum: 60 }, on: :with_meta
  validates_presence_of :content, on: :with_content

  state_machine :state, initial: :draft do
    event :publish do
      transition draft: :published
    end

    event :unpublish do
      transition published: :draft
    end

    state :draft
    state :published

    before_transition any => :published do |story|
      story.published_at = Time.zone.now
    end

    before_transition published: :draft do |story|
      story.published_at = nil
    end
  end
end

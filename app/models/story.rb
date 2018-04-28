class Story < ApplicationRecord
  belongs_to :user

  validates :title, presence: true,
                    length: { maximum: 60 }, on: :with_meta
  validates_presence_of :content, on: :with_content

  state_machine :state, initial: :draft do
    event :publish do
      transition draft: :public
    end

    event :unpublish do
      transition public: :draft
    end

    state :draft
    state :public

    before_transition any => :public do |story|
      story.published_at = Time.zone.now
    end

    before_transition public: :draft do |story|
      story.published_at = nil
    end
  end

  scope :drafts, -> { with_state(:draft)  }
  scope :published, -> { with_state(:public)  }
end

class Pod < ApplicationRecord
  before_validation :preprocess_content
  before_save :check_for_story
  belongs_to :user, counter_cache: true
  has_many :comments, as: :commentable
  has_many :reactions, as: :reactable, dependent: :delete_all
  has_many_attached :images

  validates_presence_of :content
  validates_length_of :content, maximum: 8000, if: :is_story?
  validates_length_of :content, maximum: 280, unless: :is_story?

  scope :newest, -> { order(created_at: :desc) }
  scope :no_deleted, -> { where(pending_delete: false) }

  def purge
    update_attribute(:pending_delete, true)
    DestroyPodJob.perform_later(id)
  end

  private
    def is_story?
      self.content.present? && Reddhub::Pod.story?(self.content)
    end

    def check_for_story
      return unless is_story?

      title, description, body = Reddhub::Pod.parse_story(self.content)
      self.title = title
      self.description = description
      self.content_html = ApplicationController.helpers.markdown(body)
      self.kind = Reddhub::Pod::STORY
    end

    def preprocess_content
      if content.present?
        self.content = Reddhub::Sanitizer.extra_space(content)
      end
    end
end

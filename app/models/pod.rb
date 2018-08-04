class Pod < ApplicationRecord
  before_validation :preprocess_content
  before_save :markdownfy
  belongs_to :user, counter_cache: true
  has_many :comments, as: :commentable
  has_many :reactions, as: :reactable, dependent: :delete_all
  has_many_attached :images

  with_options unless: :story_format? do |pod|
    pod.validates :content, presence: true
    pod.validates :content, length: { maximum: 280 }
  end

  with_options if: :story_format? do |pod|
    pod.validates :title, length: { maximum: 100 }
    pod.validates :description, length: { maximum: 150 }
    pod.validates :content, length: { maximum: 8000 }
  end

  scope :newest, -> { order(created_at: :desc) }
  scope :no_deleted, -> { where(pending_delete: false) }

  def purge
    update_attribute(:pending_delete, true)
    DestroyPodJob.perform_later(id)
  end

  def story?
    self.kind == Reddhub::Pod::STORY
  end

  def pod?
    self.kind == Reddhub::Pod::POD
  end

  private
    def story_format?
      self.kind == Reddhub::Pod::STORY
    end

    def markdownfy
      return unless @body.present? && story_format?
      self.content_html = ApplicationController.helpers.markdown(@body)
    end

    def check_for_story
      meta = Reddhub::Pod.parse_story(self.content)

      return if meta.nil?

      title, description, @body = meta

      self.title = title
      self.description = description
      self.kind = Reddhub::Pod::STORY
    end

    def preprocess_content
      if content.present?
        self.content = Reddhub::Sanitizer.extra_space(content)
      end

      check_for_story
    end
end

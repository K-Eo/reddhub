class Pod < ApplicationRecord
  before_validation :preprocess_content
  belongs_to :user, counter_cache: true
  has_many :comments, as: :commentable
  has_many :reactions, as: :reactable, dependent: :delete_all
  has_many_attached :images

  validates_presence_of :content
  validates_length_of :content, maximum: 280, if: :pod?

  scope :newest, -> { order(created_at: :desc) }
  scope :no_deleted, -> { where(pending_delete: false) }

  def purge
    update_attribute(:pending_delete, true)
    DestroyPodJob.perform_later(id)
  end

  private

    def pod?
      self.class == Pod
    end

    def preprocess_content
      if content.present?
        self.content = Reddhub::Sanitizer.extra_space(content)
      end
    end
end

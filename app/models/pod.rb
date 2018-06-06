class Pod < ApplicationRecord
  before_validation :preprocess_content
  belongs_to :user, counter_cache: true
  has_many :comments, as: :commentable
  has_many :reactions, as: :reactable

  validates :content, presence: true,
                      length: { maximum: 280 }

  scope :newest, -> { order(created_at: :desc) }
  scope :no_deleted, -> { where(pending_delete: false) }

  def mark_as_delete
    update_attribute(:pending_delete, true)
  end

  private

    def preprocess_content
      if content.present?
        self.content = content
                        .strip
                        .encode(universal_newline: true)
                        .gsub(/ +\n/, "\n")
                        .gsub(/\n\n\n*/, "\n\n")
      end
    end
end

class Pod < ApplicationRecord
  before_validation :content_squeeze_new_lines
  belongs_to :user, counter_cache: true
  has_many :comments, as: :commentable
  has_many :reactions, as: :reactable

  validates :content, presence: true,
                      length: { maximum: 280 }

  scope :newest, -> { order(created_at: :desc) }

  private

    def content_squeeze_new_lines
      if content.present?
        self.content = content.gsub(/[\n]{3,}/, "\n\n").strip
      end
    end
end

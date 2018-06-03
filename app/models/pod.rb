class Pod < ApplicationRecord
  before_validation :content_squeeze_new_lines
  belongs_to :user, counter_cache: true
  has_many :comments, as: :commentable
  has_many :reactions, as: :reactable

  validates :content, presence: true
  validate :content_weight

  scope :newest, -> { order(created_at: :desc) }

  private

    def content_squeeze_new_lines
      if content.present?
        self.content = content.gsub(/[\n]{3,}/, "\n\n").strip
      end
    end

    def content_weight
      if content.present?
        result = Twitter::TwitterText::Validation.parse_tweet(content)
        errors_options = { count: 280 }
        errors.add(:content, :too_long, errors_options) unless result[:valid]
      end
    end
end

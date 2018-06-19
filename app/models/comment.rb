class Comment < ApplicationRecord
  before_validation :preprocess_body
  belongs_to :commentable, polymorphic: true, counter_cache: true
  belongs_to :user
  has_many :reactions, as: :reactable, dependent: :delete_all

  validates :body, presence: true,
                   length: { maximum: 8000 }

  scope :newest, -> { order(created_at: :desc) }

  private

    def preprocess_body
      if body.present?
        self.body = Reddhub::Sanitizer.extra_space(body)
      end
    end
end

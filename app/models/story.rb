class Story < Pod
  validates_length_of :content, maximum: 8000
  validate :ensure_story
  before_save :extract_metadata

  def self.story?(content)
    content.match(/\A# \S.+/)
  end

  private

    def ensure_story
      if content.present? && !Story.story?(content)
        errors.add(:story, "is not a story")
      end
    end

    def extract_metadata
      title, description = content.match(/\A# (\S.+)\n\n(.+)/).captures

      self.title = title[0,100]
      self.description = description[0,150]
    end
end

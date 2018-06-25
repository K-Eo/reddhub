module Reddhub
  module Pod
    STORY_REGEX = /\A# \S.+\n\n\S.+\n\n\S.+/
    STORY_META_REGEX = /\A# (\S[^\n]+)\n\n(\S[^\n]+)\n\n(.*)\z/m

    POD = 0
    STORY = 1

    class << self
      def story?(content)
        content.match(STORY_REGEX)
      end

      def parse_story(content)
        content.match(STORY_META_REGEX).captures
      end
    end
  end
end

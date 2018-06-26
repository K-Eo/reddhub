module Reddhub
  module Pod
    STORY_META_REGEX = /\A# (\S[^\n]+)\n\n(\S[^\n]+)\n\n(\S.*)\z/m

    POD = 0
    STORY = 1

    class << self
      def parse_story(content)
        return nil if content.nil?

        matches = content.match(STORY_META_REGEX)

        return nil if matches.nil?

        content.match(STORY_META_REGEX).captures
      end
    end
  end
end

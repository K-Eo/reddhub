module Reddhub
  module Pod
    STORY_REGEX = /\A# \S.+/
    STORY_META_REGEX = /\A# (\S[^\n]+)\n\n([^\n]+)\n*(.*)\z/m
  end
end

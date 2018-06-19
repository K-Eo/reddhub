module Reddhub
  module Sanitizer
    def self.extra_space(text)
      text
        .strip
        .encode(universal_newline: true)
        .gsub(/ +\n/, "\n")
        .gsub(/\n\n\n*/, "\n\n")
    end
  end
end

module Reddhub
  module Sanitizer
    class << self
      def extra_space(text)
        text
          .strip
          .encode(universal_newline: true)
          .gsub(/ +\n/, "\n")
          .gsub(/\n\n\n*/, "\n\n")
      end
    end
  end
end

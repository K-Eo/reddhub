module Reddhub
  module Access
    USER = 0
    ROOT = 100

    class << self
      delegate :values, to: :options

      def options
        {
          "User" => USER,
          "Root" => ROOT
        }
      end
    end
  end
end

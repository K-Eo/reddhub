module Reddhub
  module Reaction
    ONE = "+1".freeze
    HEART = "heart".freeze
    LAUGHING = "laughing".freeze
    ASTONISHED = "astonished".freeze
    DISAPPOINTED = "disappointed_relieved".freeze
    RAGE = "rage".freeze

    class << self
      delegate :values, to: :options

      def options
        {
          "One" => ONE,
          "Heart" => HEART,
          "Laughing" => LAUGHING,
          "Astonished" => ASTONISHED,
          "Disappointed" => DISAPPOINTED,
          "Rage" => RAGE
        }
      end

      def default
        ONE
      end

      def sanitize(name)
        if name.nil? || !values.include?(name)
          default
        else
          name
        end
      end
    end
  end
end

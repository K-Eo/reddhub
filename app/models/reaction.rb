class Reaction < ApplicationRecord
  DEFAULT_NAME = "+1".freeze
  NAMES = [DEFAULT_NAME, "heart", "laughing", "astonished", "disappointed_relieved", "rage"].freeze

  belongs_to :user
  belongs_to :reactable, polymorphic: true, counter_cache: true

  validates :name, presence: true,
                   inclusion: { in: Reaction::NAMES }

  class << self
    def votes_for_collection(ids, type)
      select("name", "reactable_id", "COUNT(*) as count")
        .where("reactable_type = ? AND reactable_id IN (?)", type, ids)
        .group("name", "reactable_id")
    end
  end
end

class Reaction < ApplicationRecord
  belongs_to :user
  belongs_to :reactable, polymorphic: true, counter_cache: true

  validates :name, presence: true,
                   inclusion: { in: Reddhub::Reaction.values }

  class << self
    def votes_for_collection(ids, type)
      select("name", "reactable_id", "COUNT(*) as count")
        .where("reactable_type = ? AND reactable_id IN (?)", type, ids)
        .group("name", "reactable_id")
    end
  end
end

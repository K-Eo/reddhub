module ReactionsHelper
  def reacted?(reactions, reactable, user)
    return false if reactions.nil? || user.nil?
    reactions.find { |i| i.reactable_id == reactable.id && i.user_id == user.id }
  end
end

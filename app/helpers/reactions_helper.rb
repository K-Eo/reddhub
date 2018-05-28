module ReactionsHelper
  def reacted?(reactions, pod_id, user_id)
    reactions.find { |i| i.reactable_id == pod_id && i.user_id == user_id }
  end
end

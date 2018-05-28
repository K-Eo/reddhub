class HomeController < ApplicationController
  before_action :authenticate_user!
  layout "home"

  def show
    @user = current_user
    @pods = current_user.feed.page(params[:page])
    @pods_ids = @pods.map(&:id)
    @reactions = Reaction.votes_for_collection(@pods_ids, "Pod").group_by(&:reactable_id)
    @votes = Reaction.select("name", "reactable_id", "user_id")
      .where("reactable_type = ? AND reactable_id IN (?) AND user_id = ?", "Pod", @pods_ids, current_user.id)
    @pod = Pod.new
  end
end

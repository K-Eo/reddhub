class Pods::ReactionsController < ReactionsController
  before_action :authenticate_user!
  before_action :set_reactable

  private

    def set_reactable
      @reactable = Pod.find(params[:pod_id])
    end
end

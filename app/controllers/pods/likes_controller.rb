class Pods::LikesController < LikesController
  before_action :set_likeable

  private

    def set_likeable
      @likeable = Pod.find(params[:pod_id])
    end
end

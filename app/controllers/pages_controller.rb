class PagesController < ApplicationController
  def terms
  end

  def privacy
  end

  def disclaimer
  end

  def noscript
    render layout: "noscript"
  end
end

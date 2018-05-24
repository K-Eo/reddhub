module Likeable
  extend ActiveSupport::Concern

  included do
    has_many :likes, as: :likeable
  end

  def liked_by(user)
    likes.where(user: user).first_or_create
  end

  def unliked_by(user)
    likes.where(user: user).destroy_all
  end
end

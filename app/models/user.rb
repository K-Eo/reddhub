class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable, :lockable

  has_one_attached :avatar
  has_one_attached :original

  has_many :likes
  has_many :pods, dependent: :destroy
  has_many :stories, dependent: :destroy
  has_many :comments, dependent: :destroy

  has_many :active_relationships, class_name: "Relationship",
                                  foreign_key: "follower_id",
                                  dependent: :destroy
  has_many :following, through: :active_relationships, source: :followed

  has_many :passive_relationships, class_name: "Relationship",
                                   foreign_key: "followed_id",
                                   dependent: :destroy
  has_many :followers, through: :passive_relationships, source: :follower


  validates :username, presence: true,
                       format: { with: /\A[a-zA-Z0-9_]*\z/i },
                       length: { minimum: 4, maximum: 32 },
                       uniqueness: { case_sensitive: false }

  validates :name, presence: true,
                   length: { maximum: 96 },
                   format: { with: /\A(\p{Lu}[\p{Ll}]+)(\s\p{Lu}[\p{Ll}]+)*\z/ }

  def likes?(pod)
    pod.likes.where(user: self).exists?
  end

  def follow(user)
    following << user
  end

  def unfollow(user)
    following.destroy(user)
  end

  def following?(user)
    following.include?(user)
  end

  def feed
    following_ids = "SELECT followed_id FROM relationships WHERE follower_id = :user_id"

    Pod.includes(user: :avatar_attachment)
       .where("user_id IN (#{following_ids}) OR user_id = :user_id", user_id: id)
       .order(created_at: :desc)
  end
end

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable, :lockable

  has_one_attached :avatar
  has_one_attached :original
  has_one_attached :cover

  has_many :reactions, dependent: :destroy
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
  validate :username_exclusion

  validates :name, presence: true,
                   length: { maximum: 96 },
                   format: { with: /\A(\p{Lu}[\p{L}]*)(\s\p{Lu}[\p{L}]*)*\z/ }

  scope :username_finder, -> (query) do
    where("username LIKE ?", "%#{sanitize_sql_like(query)}%")
  end

  def username_exclusion
    if username.present? && Reddhub::Username::RESERVED.include?(username.downcase)
      errors.add(:username, :exclusion)
    end
  end

  def reactions_for(reactables, type)
    if guest?
      Hash.new
    else
      reactions
        .select("id", "name", "reactable_id", "user_id")
        .where("reactable_type = ? AND reactable_id IN (?)", type, reactables.map(&:id))
        .index_by(&:reactable_id)
    end
  end

  def reaction(reactable)
    if guest?
      nil
    else
      reactions.where(reactable: reactable).first
    end
  end

  def reacted?(reaction)
    if reaction.nil? || guest? || reaction.user_id != id
      false
    else
      true
    end
  end

  def react(reactable, name)
    reactable
      .reactions
      .where(user: self, name: sanitize_emoji_name(name))
      .first_or_create
  end

  def unreact(reactable)
    reactable
      .reactions
      .where(user: self)
      .destroy_all
  end

  def follow(user)
    raise NotDifferentUsers if user == self

    following << user
  end

  def unfollow(user)
    following.destroy(user)
  end

  def following?(user)
    following.include?(user)
  end

  def guest?
    false
  end

  def feed
    following_ids = "SELECT followed_id FROM relationships WHERE follower_id = :user_id"

    Pod.includes(user: [{ avatar_attachment: :blob }])
       .where("user_id IN (#{following_ids}) OR user_id = :user_id", user_id: id)
       .order(created_at: :desc)
  end

  class NotDifferentUsers < StandardError
  end

  private

    def sanitize_emoji_name(name)
      if name.nil? || !Reaction::NAMES.include?(name)
        Reaction::DEFAULT_NAME
      else
        name
      end
    end
end

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable, :lockable

  has_many :stories, dependent: :destroy
  has_one_attached :avatar

  validates :username, presence: true,
                       format: { with: /\A[a-zA-Z0-9_]*\z/i },
                       length: { minimum: 4, maximum: 32 },
                       uniqueness: { case_sensitive: false }

  validates :name, presence: true,
                   length: { maximum: 96 },
                   format: { with: /\A(\p{Lu}[\p{Ll}]+)(\s\p{Lu}[\p{Ll}]+)*\z/ }
end

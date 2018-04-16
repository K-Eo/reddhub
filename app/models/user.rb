class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable, :lockable

  has_many :stories, dependent: :destroy

  validates :username, presence: true,
                       format: { with: /\A[a-zA-Z0-9_]*\z/i },
                       length: { minimum: 4, maximum: 32 },
                       uniqueness: { case_sensitive: false }
end

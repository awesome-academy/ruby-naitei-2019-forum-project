class Member < ApplicationRecord
  belongs_to :sub_forum
  belongs_to :user
  validates :user_type,
    presence: true
  scope :type, ->(type){where(user_type: type)}
  scope :active_members, ->{where.not(user_type: Settings.banned_user)}
  has_many :posts
  has_many :comments
  has_many :post_interactions
  has_many :active_interactions, through: :post_interactions, source: :post
end

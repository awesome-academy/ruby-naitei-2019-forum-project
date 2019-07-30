class Member < ApplicationRecord
  belongs_to :sub_forum
  belongs_to :user

  has_many :posts
  has_many :comments
  has_many :post_interactions
  has_many :active_interactions, through: :post_interactions, source: :post
end

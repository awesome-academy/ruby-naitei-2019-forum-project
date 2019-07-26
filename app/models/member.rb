class Member < ApplicationRecord
  belongs_to :sub_forum
  belongs_to :user
  has_many :posts
end

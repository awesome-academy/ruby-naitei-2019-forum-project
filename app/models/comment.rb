class Comment < ApplicationRecord
  belongs_to :post
  belongs_to :member

  def children
    Comment.where(parent_id: id)
  end
end

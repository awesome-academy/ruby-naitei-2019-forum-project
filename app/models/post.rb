class Post < ApplicationRecord
  belongs_to :member

  has_many :users_interacted, class_name: PostInteraction.name,
                              foreign_key: :post_id
  has_many :passive_interactions, through: :users_interacted, source: :member
  
  def votes
    n = PostInteraction.where(post_id: id).try(:sum, "vote") || 0
    n < 0 ? 0 : n
  end
  
  def self.search q
    ApplicationController.helpers.search q, ngram = 3, Post, Settings.relevant_record,
      [:id, 0], [:content, Settings.post.content]
  end
end

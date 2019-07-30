class Post < ApplicationRecord
  has_many :comments
  belongs_to :member

  has_many :users_interacted, class_name: PostInteraction.name,
                              foreign_key: :post_id
  has_many :passive_interactions, through: :users_interacted, source: :member
  scope :trending_posts, ->{last(Settings.number_of_trending_posts)}
  scope :popular_posts, ->{last(Settings.number_of_popular_posts)}
  scope :personal,
    ->(user){where(member_id: Member.where(sub_forum_id: user.not_banned_forums))}

  def votes
    n = PostInteraction.where(post_id: id).try(:sum, "vote") || 0
    n < 0 ? 0 : n
  end

  def self.search q
    ApplicationController.helpers.search q, ngram = 3, Post, Settings.relevant_record,
      [:id, 0], [:content, Settings.post.content], [:content, Settings.post.title]
  end

  def sub_forum
    member = Member.find_by id: member_id
    SubForum.find_by id: member.sub_forum_id
  end
end

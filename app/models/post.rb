class Post < ApplicationRecord
  belongs_to :member

  def self.search q
    ApplicationController.helpers.search q, ngram = 3, Post, Settings.relevant_record,
      [:id, 0], [:content, Settings.post.content]
  end
end
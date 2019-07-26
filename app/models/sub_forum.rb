class SubForum < ApplicationRecord
  has_many :members, dependent: :destroy
  has_many :users, through: :members

  belongs_to :user
  validates :user_id,
    presence: true
  validates :name,
    presence: true,
    length: {maximum: Settings.maximum_name_length},
    uniqueness: {case_sensitive: true}
  
  scope :trending_forums,-> {last(Settings.number_of_trending_forums).reverse}

  def self.search q
    ApplicationController.helpers.search q, ngram = 3, SubForum,
      [:id, 0], [:name, Settings.sub_forum.name],
      [:description, Settings.sub_forum.description]
  end
end

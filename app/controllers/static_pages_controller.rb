class StaticPagesController < ApplicationController
  def home
    @trending_sub_forums = SubForum.trending_forums
  end
end

class StaticPagesController < ApplicationController
  def home
    @trending_sub_forums = SubForum.trending_forums
    @trending_posts = Post.trending_posts
    @popular_posts = if current_user && params[:popular]
                       Post.personal(current_user).popular_posts
                     else
                       Post.popular_posts
                     end
  end
end

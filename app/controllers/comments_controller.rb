class CommentsController < ApplicationController
  before_action :load_post, only: :create

  def create
    member = Member.find_by user_id: current_user.id,
      sub_forum_id: @post.sub_forum.id

    @comment = Comment.new post_id: @post.id,
      parent_id: params[:parent_id], member_id: member.id,
      content: params[:comment_content]

    if @comment.save
      respond_to do |f|
        f.html{redirect_to @post}
        f.js
      end
    end
  end

  private

  def load_post
    @post = Post.find_by id: params[:post_id]
    redirect_to root_url unless @post
  end
end

class PostInteractionsController < ApplicationController
  before_action :load_post, :load_member, only: :update

  def update
    @interaction = PostInteraction.find_by member_id: @member.id,
      post_id: @post.id

    if @interaction.nil?
      @interaction = PostInteraction.new member_id: @member.id,
        post_id: @post.id
      @interaction.update_attributes interaction_params
    else
      if params[:interaction_type] == Settings.post_vote
        interact :vote
      else
        interact :interaction_type
      end
    end

    respond_to do |f|
      f.html{redirect_to @post}
      f.js
    end
  end

  private

  def interact type
    @interaction.update_attributes type =>
      (@interaction.send(type) == params[type].to_i ? nil : params[type])
  end

  def interaction_params
    params.permit %w(interaction_type vote post_id)
  end

  def load_post
    @post = Post.find_by id: params[:post_id]
    redirect_to root_url unless @post
  end

  def load_member
    p_member = Member.find_by id: @post.member_id

    @member = Member.find_by user_id: current_user.id,
      sub_forum_id: p_member.sub_forum_id

    redirect_to root_url unless @member
  end
end

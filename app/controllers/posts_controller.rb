class PostsController < ApplicationController
  before_action :check_current_user, only: %i(new create)
  before_action :load_member, only: :create
  before_action :load_post, only: %i(show update)

  def new; end

  def create
    @post = Post.new member_id: @member.id, content: params[:content]

    if @post.save
      flash[:notice] = t ".success_create_post"
      redirect_to @post
    else
      render :new
    end
  end

  def show; end

  def update
    if @post.update_attributes post_params
      respond_to do |f|
        f.html{redirect_to post_url}
        f.js
      end
    end

    flash[:warning] = t ".create.fail_to_edit_post"
  end

  private

  def load_member
    @member = Member.find_by sub_forum_id: params[:sub_forum_id],
                             user_id: current_user.id
    redirect_to root_url unless @member
  end

  def check_current_user
    redirect_to root_url if current_user.nil?
  end

  def post_params
    params.permit %i(content)
  end

  def load_post
    @post = Post.find_by id: params[:id]
    redirect_to root_url unless @post
  end
end

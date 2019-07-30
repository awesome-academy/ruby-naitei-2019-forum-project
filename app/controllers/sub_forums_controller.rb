class SubForumsController < ApplicationController
  before_action :find_forum_by_id, only: %i(show destroy edit update)
  before_action :check_correct_user, only: %i(destroy update)

  def new
    @sub_forum = SubForum.new
  end

  def create
    @sub_forum = current_user.sub_forums.build sub_forum_params

    if @sub_forum.save
      current_user.join @sub_forum, Settings.admin_forum
      redirect_to @sub_forum
    else
      render :new
    end
  end

  def show
    @mods = @sub_forum.members.type Settings.mod_forum
    @posts = @sub_forum.posts
  end

  def edit
    @admin = @sub_forum.members.type Settings.admin_forum
    @mods = @sub_forum.members.type Settings.mod_forum
    @normal_members = @sub_forum.members.type Settings.member_forum
    @banned_members = @sub_forum.members.type Settings.banned_user
  end

  def update
    if @sub_forum.update_attributes(sub_forum_params)
      flash[:success] = t ".sub_forum_updated"
      redirect_to edit_sub_forum_path(@sub_forum)
    else
      render root_url
    end
  end

  def destroy
    @sub_forum.destroy
    redirect_to request.referrer || root_url
  end

  private

  def sub_forum_params
    permit_symbols = [:description]
    permit_symbols << :name if params[:action] == "create"
    params.require(:sub_forum).permit permit_symbols
  end

  def check_correct_user
    return if current_user == @sub_forum.user
    flash[:danger] = t "not_authorized"
    redirect_to root_url
  end

  def find_forum_by_id
    @sub_forum = SubForum.find_by(id: params[:id])
    return if @sub_forum
    flash[:danger] = t ".sub_forum_not_found"
    redirect_to root_url
  end
end
